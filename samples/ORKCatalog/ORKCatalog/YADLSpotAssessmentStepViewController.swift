//
//  YADLSpotAssessmentStepViewController.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/22/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

struct YADLSpotAssessmentAnswerStruct {
    var identifier: protocol<NSCoding, NSCopying, NSObjectProtocol>
    var selected: Bool
}

class YADLSpotAssessmentStepViewController: ORKStepViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var nothingToReportButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
//    var answerArray: [YADLSpotAssessmentAnswerStruct]?
    var answerDictionary: [Int: YADLSpotAssessmentAnswerStruct]?
    
    //whenver step is set, initialize the answerArray
    override var step: ORKStep? {
        didSet {
            guard let step = step as? YADLSpotAssessmentStep,
                let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat
                else { return }
            
            self.answerDictionary = [Int: YADLSpotAssessmentAnswerStruct]()
            answerFormat.imageChoices.forEach { imageChoice in
                self.answerDictionary![imageChoice.value.hash] = YADLSpotAssessmentAnswerStruct(identifier: imageChoice.value, selected: false)
            }
        }
    }
    
    override var result: ORKStepResult? {
        let parentResult = super.result
        let step = self.step as? YADLSpotAssessmentStep
        
        let questionResult = ORKChoiceQuestionResult(identifier: step!.identifier)
        questionResult.choiceAnswers = self.selectedAnswers()
        questionResult.startDate = parentResult?.startDate
        questionResult.endDate = parentResult?.endDate
        
        parentResult?.results = [questionResult]
        
        return parentResult
    }
    
    func getSelectedForValue(value: protocol<NSCoding, NSCopying, NSObjectProtocol>) -> Bool? {
        guard let answerDictionary = self.answerDictionary,
            let answer = answerDictionary[value.hash]
            else { return nil }
        
        return answer.selected
    }
    
    func setSelectedForValue(value: protocol<NSCoding, NSCopying, NSObjectProtocol>, selected: Bool) {
        self.answerDictionary![value.hash] = YADLSpotAssessmentAnswerStruct(identifier: value, selected: selected)
    }
    
    func selectedAnswers() -> [protocol<NSCoding, NSCopying, NSObjectProtocol>]? {
        guard let answerDictionary = self.answerDictionary
            else { return nil }
        
        return answerDictionary.filter { (key, answer) in
            return answer.selected
            }
            .map { (key, selectedAnswer) in
                return selectedAnswer.identifier
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagesCollectionView.registerNib(UINib(nibName: "YADLSpotAssessmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "yadl_spot")
        
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.backgroundColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
        self.nothingToReportButton.backgroundColor = UIColor.yellowColor()
        self.nothingToReportButton.titleLabel?.textColor = UIColor.whiteColor()
        
        self.submitButton.backgroundColor = UIColor.blueColor()
        self.submitButton.titleLabel?.textColor = UIColor.whiteColor()
        
        if let step = self.step as? YADLSpotAssessmentStep {
            self.questionTextView.text = step.title
        }
        
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        //nothing to report button is enabled IFF there are no selected images
        //submit button is enabled IFF there are 1 or more selected images
        //submit button title contains the number of selected images
        if let selectedAnswers = self.selectedAnswers() {
            self.nothingToReportButton.enabled = (selectedAnswers.count == 0)
            self.submitButton.enabled = (selectedAnswers.count > 0)
            self.submitButton.setTitle("Submit (\(selectedAnswers.count))", forState: UIControlState.Normal)
            print("number of selected answers: \(selectedAnswers.count)")
        }
        
        //reload collection view
        self.imagesCollectionView.reloadData()
    }
    
    // MARK: - UICollectionView Methods
    func imageChoiceAtIndex(index: Int) -> ORKImageChoice? {
        guard let step = step as? YADLSpotAssessmentStep,
            let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat
            else { return nil }
        
        return answerFormat.imageChoices[index]
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let step = step as? YADLSpotAssessmentStep,
            let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat
            else { return 0 }
        
        return answerFormat.imageChoices.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("yadl_spot", forIndexPath: indexPath)
        
        guard let yadlCell = cell as? YADLSpotAssessmentCollectionViewCell,
            let imageChoice = self.imageChoiceAtIndex(indexPath.row)
        else {
            return cell
        }
        yadlCell.activityImage = imageChoice.normalStateImage
        yadlCell.selected = self.getSelectedForValue(imageChoice.value)!
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let imageChoice = self.imageChoiceAtIndex(indexPath.row)
            else { return }
        
        self.setSelectedForValue(imageChoice.value, selected: !self.getSelectedForValue(imageChoice.value)!)
        
        self.updateUI()
        
    }
    
    @IBAction func nothingToReportSelected(sender: AnyObject) {
        print("nothing to report selected")
        if let delegate = self.delegate {
            delegate.stepViewControllerResultDidChange(self)
        }
        self.goForward()
    }
    
    @IBAction func submitSelected(sender: AnyObject) {
        print("submit selected")
        if let delegate = self.delegate {
            delegate.stepViewControllerResultDidChange(self)
        }
        self.goForward()
    }
    
    

}
