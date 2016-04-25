//
//  YADLFullAssessmentStep.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class YADLFullAssessmentStep: ORKQuestionStep {

    var image: UIImage?
    
    func stepViewControllerClass() -> AnyClass {
        return YADLFullAssessmentStepViewController.self
    }

    init(identifier: String,
         title: String,
         text: String,
         image: UIImage,
         answerFormat: ORKAnswerFormat ) {
        

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
