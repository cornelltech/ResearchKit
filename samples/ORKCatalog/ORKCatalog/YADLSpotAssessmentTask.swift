//
//  YADLSpotAssessmentTask.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/27/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class YADLSpotAssessmentTask: ORKOrderedTask {
    
    class func loadStepsFromJSON(json: AnyObject) -> [ORKStep]? {
        
        guard let prompt = json.objectForKey(kPromptTag) as? String
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let identifier = json.objectForKey(kIdentifierTag) as? String
            else {
                fatalError("Missing or Malformed Identifier")
        }
        
        guard let activitiesParameters = json.objectForKey(kActivitiesTag) as? [AnyObject],
            let activities = YADLFullAssessmentTask.loadActivitiesFromJSON(activitiesParameters)
            else {
                fatalError("Missing or Malformed Activities")
        }
        
        guard let optionsDictionary = json.objectForKey(kOptionsTag) as? [String: AnyObject]
            else {
                fatalError("Missing or Malformed Options")
        }
        
        guard let summaryParameters = json.objectForKey(kSummaryTag),
            let summary = YADLFullAssessmentTask.loadSummaryFromJSON(summaryParameters)
            else {
                fatalError("Missing or Malformed Summary")
        }
        
        let imageChoices = activities.map { activity in
            
            return ORKImageChoice(normalImage: activity.image, selectedImage: nil, text: activity.description, value: activity.identifier)
            
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithImageChoices(imageChoices)
        
        let spotAssessmentStep = YADLSpotAssessmentStep(identifier: identifier, title: prompt, answerFormat: answerFormat)
        
        if let submitButtonColor = optionsDictionary[kOptionsSubmitButtonColorTag] as? String {
            spotAssessmentStep.submitButtonColor = UIColor(hexString: submitButtonColor)
        }
        
        if let submitButtonColor = optionsDictionary[kOptionsSubmitButtonColorTag] as? String {
            spotAssessmentStep.submitButtonColor = UIColor(hexString: submitButtonColor)
        }
        
        if let nothingToReportButtonColor = optionsDictionary[kOptionsNothingToReportButtonColorTag] as? String {
            spotAssessmentStep.nothingToReportButtonColor = UIColor(hexString: nothingToReportButtonColor)
        }
        
        if let activityCellSelectedColor = optionsDictionary[kOptionsActivityCellSelectedColorTag] as? String {
            spotAssessmentStep.activityCellSelectedColor = UIColor(hexString: activityCellSelectedColor)
        }
        
        if let activityCellSelectedOverlayImageTitle = optionsDictionary[kOptionsActivityCellSelectedOverlayImageTitleTag] as? String {
            spotAssessmentStep.activityCellSelectedOverlayImage = UIImage(named: activityCellSelectedOverlayImageTitle)
        }
        
        if let activityCollectionViewBackgroundColor = optionsDictionary[kOptionsActivityCellSelectedOverlayImageTitleTag] as? String {
            spotAssessmentStep.activityCollectionViewBackgroundColor = UIColor(hexString: activityCollectionViewBackgroundColor)
        }
        
        spotAssessmentStep.activitiesPerRow = optionsDictionary[kOptionsActivitiesPerRowTag] as? Int
        spotAssessmentStep.activityMinSpacing = optionsDictionary[kOptionsActivityMinSpacingTag] as? CGFloat
        
        let summaryStep = ORKInstructionStep(identifier: kYADLSpotAssessmentSummaryID)
        summaryStep.title = summary.title
        summaryStep.text = summary.text
        
        return [
            spotAssessmentStep,
            summaryStep
        ]
    }
    
//    class func loadStepsFromPropertiesFile(propertiesFileName: String) throws -> [ORKStep]? {
//        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
//            else {
//                fatalError("Unable to location file with YADL Spot Assessment Section in main bundle")
//        }
//        
//        guard let fileContent = NSData(contentsOfFile: filePath)
//            else {
//                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
//        }
//        
//        let spotAssessmentParameters = try NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
//        
//        
//        return YADLSpotAssessmentTask.loadStepsFromJSON(spotAssessmentParameters)
//    }
    
    convenience init(identifier: String, propertiesFileName: String) {
        
//        let steps = try! YADLSpotAssessmentTask.loadStepsFromPropertiesFile(propertiesFileName)
//        
//        self.init(identifier: identifier, steps: steps)
        
        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to location file with YADL Spot Assessment Section in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let spotAssessmentParameters = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters)
    }
    
    convenience init(identifier: String, json: AnyObject) {
        
        let steps = YADLSpotAssessmentTask.loadStepsFromJSON(json)
        
        self.init(identifier: identifier, steps: steps)
    }
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
