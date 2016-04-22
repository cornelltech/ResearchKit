//
//  YADLStepViewController.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/6/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class YADLStepViewController: ORKStepViewController {

    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var activityDescriptionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var buttons: [UIButton]?
    var buttonHeightContraints: [NSLayoutConstraint]?
    var buttonHeight: CGFloat = 60.0 {
        willSet(newHeight) {
            self.buttonHeightContraints?.forEach { constraint in
                constraint.constant = newHeight
            }
        }
    }
    
    var answer: protocol<NSCoding, NSCopying, NSObjectProtocol>?
    
    override var result: ORKStepResult? {
        let parentResult = super.result
        if let answer = self.answer {
            let step = self.step as? YADLFullAssessmentQuestionStep
            
            let questionResult = ORKChoiceQuestionResult(identifier: step!.identifier)
            questionResult.choiceAnswers = [answer]
            questionResult.startDate = parentResult?.startDate
            questionResult.endDate = parentResult?.endDate
            
            parentResult?.results = [questionResult]
        }

        return parentResult
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor.lightGrayColor()
        
        if let step = self.step as? YADLFullAssessmentQuestionStep {
            self.activityImageView.image = step.image
            self.activityDescriptionLabel.text = step.title
            //setupButtons
            self.setupDifficultyButtons()
            
            self.setupQuestionTextView(step)
            
            
        }
        else {
            //should throw here
        }
        
    }
    
    func setupQuestionTextView(step: YADLFullAssessmentQuestionStep) {
        
        self.questionTextView.text = step.text
        self.questionTextView.textAlignment = NSTextAlignment.Center
        self.questionTextView.font = UIFont.boldSystemFontOfSize(18.0)
        
    }
    
    //note that this was setupButtons, but changed due to namespace conlict
    func setupDifficultyButtons() {
        
        self.buttonStackView.layoutMarginsRelativeArrangement = true
        
        if let buttons = self.buttons {
            buttons.forEach { button in
                button.removeFromSuperview()
            }
            self.buttons = nil
            self.buttonHeightContraints = nil
        }
        if let step = self.step as? YADLFullAssessmentQuestionStep {
            if let answerFormat = step.answerFormat as? ORKTextChoiceAnswerFormat {
                
                self.buttons = answerFormat.textChoices.enumerate().map { (i, textChoice) in
                    let button = UIButton(type: UIButtonType.System)
                    button.setTitle(textChoice.text, forState: UIControlState.Normal)
                    
                    if let yadlTextChoice = textChoice as? YADLTextChoice {
                        button.setTitleColor(yadlTextChoice.color, forState: .Normal)
                    }
                    
//                    button.layer.cornerRadius = 10
                    button.layer.borderWidth = 1
                    button.layer.borderColor = button.titleColorForState(UIControlState.Normal)?.CGColor
                    let heightContraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.buttonHeight)
                    button.addConstraint(heightContraint)
                    
                    button.addTarget(self, action: #selector(YADLStepViewController.textChoiceButtonSelected(_:)), forControlEvents: .TouchUpInside)
                    
                    
                    return button
                }
                
                self.buttonHeightContraints = self.buttons!.map { button in
                    let constraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.buttonHeight)
                    button.addConstraint(constraint)
                    return constraint
                }
                
                self.buttons?.forEach(self.buttonStackView.addArrangedSubview)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textChoiceAtIndex(index: Int) -> ORKTextChoice? {
        print(self.step)
        if let step = self.step as? YADLFullAssessmentQuestionStep {
            if let answerFormat = step.answerFormat as? ORKTextChoiceAnswerFormat {
                return answerFormat.textChoices[index]
            }
        }
        return nil
    }
    
    func textChoiceButtonSelected(button: UIButton) {
        
        
        if let buttonIndex = self.buttons?.indexOf(button) {
            if let textChoice = self.textChoiceAtIndex(buttonIndex) {
                print("Selected \(textChoice.text) - \(textChoice.value)")
                self.answer = textChoice.value
                if let delegate = self.delegate {
                    delegate.stepViewControllerResultDidChange(self)
                }
            }
        }
        self.goForward()
        
    }

    @IBAction func skipButtonPressed(sender: AnyObject) {
        self.goForward()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
