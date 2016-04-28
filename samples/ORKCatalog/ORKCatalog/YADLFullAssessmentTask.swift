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

    //note that this is a Class method, the steps array needs to be passed to the init function
    class func loadStepsFromJSON(jsonParser: YADLJSONParser) -> [ORKStep]? {
        
        guard let prompt = jsonParser.fullAssessmentPrompt
            else {
                fatalError("Missing or Malformed Prompt")
        }
        guard let choices = jsonParser.fullAssessmentChoices
            else {
                fatalError("Missing or Malformed Choices")
        }
        
        guard let activities = jsonParser.activities
            else {
                fatalError("Missing or Malformed Activities")
        }
        
        guard let summary = jsonParser.fullAssessmentSummary
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
        
        let yadlJsonParser = YADLJSONParser(json: json)
        let steps = YADLFullAssessmentTask.loadStepsFromJSON(yadlJsonParser)
        
        self.init(identifier: identifier, steps: steps)
    }
    
    convenience init(identifier: String, propertiesFileName: String) {
        
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
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
