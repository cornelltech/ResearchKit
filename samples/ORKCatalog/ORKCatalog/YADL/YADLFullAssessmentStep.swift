//
//  YADLFullAssessmentQuestionStep.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/4/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class YADLFullAssessmentStep: ORKStep {
    
    var answerFormat: ORKAnswerFormat?
    //image
    var image: UIImage?

    func stepViewControllerClass() -> AnyClass {
        return YADLFullAssessmentStepViewController.self
    }
    
    init(identifier: String,
         title: String?,
         text: String?,
         image: UIImage?,
         answerFormat: ORKAnswerFormat? ) {
       
//        super.init(identifier: identifier, title: title, text: text, answer: answer)
        super.init(identifier: identifier)
        self.title = title
        self.text = text
        self.answerFormat = answerFormat
        self.image = image
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
