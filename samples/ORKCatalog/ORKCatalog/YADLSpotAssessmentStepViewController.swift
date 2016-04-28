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

class YADLSpotAssessmentStepViewController: ORKStepViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var nothingToReportButton: UIButton!
    
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override convenience init(step: ORKStep?) {
        self.init(nibName: "YADLSpotAssessmentStepViewController", bundle: nil)
        self.step = step
        self.restorationIdentifier = step!.identifier
        self.restorationClass = YADLSpotAssessmentStepViewController.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Params for user to configure
    
    var submitButtonColor: UIColor = UIColor.blueColor() {
        didSet {
            if let submitButton = self.submitButton {
                submitButton.backgroundColor = submitButtonColor
            }
        }
    }
    
    var nothingToReportButtonColor: UIColor = UIColor.yellowColor() {
        didSet {
            if let nothingToReportButton = self.nothingToReportButton {
                nothingToReportButton.backgroundColor = nothingToReportButtonColor
            }
        }
    }
    
    var activityCellSelectedColor:UIColor = UIColor.blueColor() {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.reloadData()
            }
        }
    }
    
    var activityCellSelectedOverlayImage: UIImage? = nil {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.reloadData()
            }
        }
    }
    
    //collection view background color
    var activityCollectionViewBackgroundColor = UIColor.clearColor() {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.backgroundColor = activityCollectionViewBackgroundColor
            }
        }
    }
    
    //collectionViewLayout properties
    var activitiesPerRow = 3 {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    var activityMinSpacing: CGFloat = 10.0 {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    
    
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
            
            if let questionTextView = self.questionTextView {
                questionTextView.text = step.title
            }
        }
    }
    
    func setupOptionsFromTask(task: YADLSpotAssessmentTask) {
        if let submitButtonColor = task.submitButtonColor {
            self.submitButtonColor = submitButtonColor
        }
        
        if let nothingToReportButtonColor = task.nothingToReportButtonColor {
            self.nothingToReportButtonColor = nothingToReportButtonColor
        }
        
        if let activityCellSelectedColor = task.activityCellSelectedColor {
            self.activityCellSelectedColor = activityCellSelectedColor
        }
        
        self.activityCellSelectedOverlayImage = task.activityCellSelectedOverlayImage
        
        if let activityCollectionViewBackgroundColor = task.activityCollectionViewBackgroundColor {
            self.activityCollectionViewBackgroundColor = activityCollectionViewBackgroundColor
        }
        
        if let activitiesPerRow = task.activitiesPerRow {
            self.activitiesPerRow = activitiesPerRow
        }
        
        if let activityMinSpacing = task.activityMinSpacing {
            self.activityMinSpacing = activityMinSpacing
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
        self.imagesCollectionView.backgroundColor = self.activityCollectionViewBackgroundColor
        
        self.submitButton.backgroundColor = self.submitButtonColor
        self.nothingToReportButton.backgroundColor = nothingToReportButtonColor

        if let step = self.step as? YADLSpotAssessmentStep {
            self.questionTextView.text = step.title
        }
        
        if let taskViewController = self.taskViewController,
            let task = taskViewController.task as? YADLSpotAssessmentTask {
            self.setupOptionsFromTask(task)
        }
        
        self.updateUI()
    }

    func updateUI() {
        //nothing to report button is visible IFF there are no selected images
        //submit button is visible IFF there are 1 or more selected images
        //submit button title contains the number of selected images
        if let selectedAnswers = self.selectedAnswers() {
            
            if selectedAnswers.count > 0 {
                self.submitButton.setTitle("Submit (\(selectedAnswers.count))", forState: UIControlState.Normal)
            }
            
            self.submitButton.hidden = !(selectedAnswers.count > 0)
            self.nothingToReportButton.hidden = (selectedAnswers.count > 0)
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
        yadlCell.selectedBackgroundColor = self.activityCellSelectedColor
        if let selectedImage = self.activityCellSelectedOverlayImage {
            yadlCell.selectedOverlayImage = selectedImage
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let imageChoice = self.imageChoiceAtIndex(indexPath.row)
            else { return }
        
        self.setSelectedForValue(imageChoice.value, selected: !self.getSelectedForValue(imageChoice.value)!)
        
        self.updateUI()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - CGFloat(self.activitiesPerRow + 1)*self.activityMinSpacing) / CGFloat(self.activitiesPerRow)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.activityMinSpacing, left: self.activityMinSpacing, bottom: self.activityMinSpacing, right: self.activityMinSpacing)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.activityMinSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.activityMinSpacing
    }
    
    
    @IBAction func submitSelected(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.stepViewControllerResultDidChange(self)
        }
        self.goForward()
    }
    
    

}
