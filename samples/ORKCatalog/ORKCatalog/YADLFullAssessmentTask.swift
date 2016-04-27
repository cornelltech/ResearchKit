//
//  YADLFullAssessmentTask.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/26/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit




class YADLFullAssessmentTask: ORKOrderedTask {
    
    
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    class func loadChoicesFromJSON(choicesParameters: [AnyObject]) -> [ChoiceStruct]? {
        
        return choicesParameters.map { choiceParameter in
            guard let choiceDict = choiceParameter as? [String: AnyObject],
                let text = choiceDict[kChoiceTextTag] as? String,
                let value = choiceDict[kChoiceValueTag] as? protocol<NSCoding, NSCopying, NSObjectProtocol>,
                let colorString = choiceDict[kChoiceColorTag] as? String
                else {
                   fatalError("Malformed Choice: \(choiceParameter)")
            }

            let color = UIColor(hexString: colorString)
            return ChoiceStruct(text: text, value: value, color: color)
        }
    }
    
    class func loadActivitiesFromJSON(activitiesParameters: [AnyObject]) -> [ActivityStruct]? {
        return activitiesParameters.map { activityParameter in
            
            guard let activityDict = activityParameter as? [String: AnyObject],
                let imageTitle = activityDict[kActivityImageTitleTag] as? String,
                let image = UIImage(named: imageTitle),
                let description = activityDict[kActivityDescriptionTag] as? String,
                let identifier = activityDict[kActivityIdentifierTag] as? String
                else {
                    fatalError("Malformed Activity: \(activityParameter)")
            }
            return ActivityStruct(image: image, description: description, identifier: identifier)
        }
    }
    
    class func loadSummaryFromJSON(summaryParameters: AnyObject) -> SummaryStruct? {
        
        guard let summaryDict = summaryParameters as? [String: AnyObject],
            let title = summaryDict[kSummaryTitleTag] as? String,
            let text = summaryDict[kSummaryTextTag] as? String
            else {
                fatalError("Malformed Summary: \(summaryParameters)")
        }
        
        return SummaryStruct(title: title, text: text)
    }
    
    class func loadStepsFromJSON(json: AnyObject) -> [ORKStep]? {
        
        guard let prompt = json.objectForKey(kPromptTag) as? String
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let choicesParameters = json.objectForKey(kChoicesTag) as? [AnyObject],
            let choices = YADLFullAssessmentTask.loadChoicesFromJSON(choicesParameters)
            else {
                fatalError("Missing or Malformed Choices")
        }
        
        guard let activitiesParameters = json.objectForKey(kActivitiesTag) as? [AnyObject],
            let activities = YADLFullAssessmentTask.loadActivitiesFromJSON(activitiesParameters)
            else {
                fatalError("Missing or Malformed Activities")
        }
        
        guard let summaryParameters = json.objectForKey(kSummaryTag),
            let summary = YADLFullAssessmentTask.loadSummaryFromJSON(summaryParameters)
            else {
                fatalError("Missing or Malformed Summary")
        }
        
        let textChoices = choices.map { choice in
            return YADLTextChoice(text: choice.text, value: choice.value, color: choice.color)
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
        
        var steps: [ORKStep] = activities.map { activity in
            
            return YADLFullAssessmentStep(identifier: activity.identifier, title: activity.description, text: prompt, image: activity.image, answerFormat: answerFormat)
            
        }
        
        let summaryStep = ORKInstructionStep(identifier: kYADLFullAssessmentSummaryID)
        summaryStep.title = summary.title
        summaryStep.text = summary.text
        
        steps.append(summaryStep)
        
        return steps
    }
    
    convenience init(identifier: String, json: AnyObject) {
        
        let steps = YADLFullAssessmentTask.loadStepsFromJSON(json)
        
        self.init(identifier: identifier, steps: steps)
    }
    
    convenience init(identifier: String, propertiesFileName: String) {
        
//        let steps = try! YADLFullAssessmentTask.loadStepsFromPropertiesFile(propertiesFileName)
//        
//        self.init(identifier: identifier, steps: steps)
        
        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to location file with YADL Full Assessment Section in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (YADL Full Assessment data)")
        }
        
        let spotAssessmentParameters = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
