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
    
    
    //note that this is a Class method, the steps array needs to be passed to the init function
    class func loadStepsFromJSON(jsonParser: YADLJSONParser, activityIdentifiers: [String]?) -> [ORKStep]? {
        
        
        guard let prompt = jsonParser.spotAssessmentPrompt
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let identifier = jsonParser.spotAssessmentIdentifier
            else {
                fatalError("Missing or Malformed Identifier")
        }
        
        guard let activities = jsonParser.activities
            else {
                fatalError("Missing or Malformed Activities")
        }
        
        guard let summary = jsonParser.spotAssessmentSummary
            else {
                fatalError("Missing or Malformed Summary")
        }
        
        let imageChoices = activities
        .filter { activity in
            if let identifiers = activityIdentifiers {
                return identifiers.contains(activity.identifier)
            }
            else {
                return true
            }
        }
        .map { activity in
            
            return ORKImageChoice(normalImage: activity.image, selectedImage: nil, text: activity.description, value: activity.identifier)
            
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithImageChoices(imageChoices)
        
        let spotAssessmentStep = YADLSpotAssessmentStep(identifier: identifier, title: prompt, answerFormat: answerFormat)
  
        let summaryStep = ORKInstructionStep(identifier: kYADLSpotAssessmentSummaryID)
        summaryStep.title = summary.title
        summaryStep.text = summary.text
        
        return [
            spotAssessmentStep,
            summaryStep
        ]
    }
    
    var submitButtonColor: UIColor?
    var nothingToReportButtonColor: UIColor?
    var activityCellSelectedColor:UIColor?
    var activityCellSelectedOverlayImage: UIImage?
    var activityCollectionViewBackgroundColor: UIColor?
    var activitiesPerRow: Int?
    var activityMinSpacing: CGFloat?
    
    func configureOptions(jsonParser: YADLJSONParser) {
        self.submitButtonColor = jsonParser.spotAssessmentSubmitButtonColor
        self.nothingToReportButtonColor = jsonParser.spotAssessmentNothingToReportButtonColor
        self.activityCellSelectedColor = jsonParser.spotAssessmentActivityCellSelectedColor
        self.activityCellSelectedOverlayImage = jsonParser.spotAssessmentActivityCellSelectedOverlayImage
        self.activityCollectionViewBackgroundColor = jsonParser.spotAssessmentActivityCollectionViewBackgroundColor
        self.activitiesPerRow = jsonParser.spotAssessmentActivitiesPerRow
        self.activityMinSpacing = jsonParser.spotAssessmentActivityMinSpacing
    }
    
    convenience init(identifier: String, propertiesFileName: String, activityIdentifiers: [String]? = nil) {

        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to location file with YADL Spot Assessment Section in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let spotAssessmentParameters = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters, activityIdentifiers: activityIdentifiers)
    }
    
    convenience init(identifier: String, json: AnyObject, activityIdentifiers: [String]? = nil) {
        
        let yadlJsonParser = YADLJSONParser(json: json)
        let steps = YADLSpotAssessmentTask.loadStepsFromJSON(yadlJsonParser, activityIdentifiers: activityIdentifiers)
        
        self.init(identifier: identifier, steps: steps)
        self.configureOptions(yadlJsonParser)
    }
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
