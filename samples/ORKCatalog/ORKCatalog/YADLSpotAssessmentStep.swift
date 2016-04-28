//
//  YADLSpotAssessmentStep.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/22/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class YADLSpotAssessmentStep: ORKQuestionStep {

//    var submitButtonColor: UIColor?
//    var nothingToReportButtonColor: UIColor?
//    var activityCellSelectedColor:UIColor?
//    var activityCellSelectedOverlayImage: UIImage?
//    var activityCollectionViewBackgroundColor: UIColor?
//    var activitiesPerRow: Int?
//    var activityMinSpacing: CGFloat?
    
    func stepViewControllerClass() -> AnyClass {
        return YADLSpotAssessmentStepViewController.self
    }
    
    init(identifier: String,
         title: String,
         answerFormat: ORKImageChoiceAnswerFormat ) {
        
        super.init(identifier: identifier)
        self.title = title
        self.answerFormat = answerFormat
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
