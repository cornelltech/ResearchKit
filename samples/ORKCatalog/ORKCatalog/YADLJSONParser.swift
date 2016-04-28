//
//  YADLConstants.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/27/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import Foundation
import UIKit

let kDefaultChoiceColor: UIColor = UIColor.blueColor()
let kFullAssessmentPromptTag = "fullAssessmentPrompt"
let kFullAssessmentIdentifierTag = "fullAssessmentIdentifier"
let kSpotAssessmentPromptTag = "spotAssessmentPrompt"
let kSpotAssessmentIdentifierTag = "spotAssessmentIdentifier"

let kChoicesTag = "choices"
let kChoiceTextTag = "text"
let kChoiceValueTag = "value"
let kChoiceColorTag = "color"

let kActivitiesTag = "activities"
let kActivityImageTitleTag = "imageTitle"
let kActivityDescriptionTag = "description"
let kActivityIdentifierTag = "identifier"

let kFullAssessmentSummaryTag = "fullAssessmentSummary"
let kSpotAssessmentSummaryTag = "spotAssessmentSummary"
let kSummaryTitleTag = "title"
let kSummaryTextTag = "text"

let kSpotAssessmentOptionsTag = "spotAssessmentOptions"
let kOptionsSubmitButtonColorTag = "submitButtonColor"
let kOptionsNothingToReportButtonColorTag = "nothingToReportButtonColor"
let kOptionsActivityCellSelectedColorTag = "activityCellSelectedColor"
let kOptionsActivityCollectionViewBackgroundColorTag = "activityCollectionViewBackgroundColor"
let kOptionsActivityCellSelectedOverlayImageTitleTag = "activityCellSelectedOverlayImageTitle"
let kOptionsActivitiesPerRowTag = "activitiesPerRow"
let kOptionsActivityMinSpacingTag = "activityMinSpacing"

let kYADLFullAssessmentSummaryID = "YADLFullSummaryStep"
let kYADLSpotAssessmentSummaryID = "YADLSpotSummaryStep"

struct ActivityStruct {
    var image: UIImage
    var description: String
    var identifier: String
}

struct ChoiceStruct {
    var text: String
    var value: protocol<NSCoding, NSCopying, NSObjectProtocol>
    var color: UIColor
}

struct SummaryStruct {
    var title: String
    var text: String
}

class YADLJSONParser: NSObject {
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
    
    
    var fullAssessmentPrompt: String? {
        return self.json.objectForKey(kFullAssessmentPromptTag) as? String
    }
    
    var spotAssessmentPrompt: String? {
        return self.json.objectForKey(kSpotAssessmentPromptTag) as? String
    }
    
    var fullAssessmentIdentifier: String? {
        return self.json.objectForKey(kFullAssessmentIdentifierTag) as? String
    }
    
    var spotAssessmentIdentifier: String? {
        return self.json.objectForKey(kSpotAssessmentIdentifierTag) as? String
    }
    
    var fullAssessmentChoices: [ChoiceStruct]? {
        guard let choicesParameters = self.json.objectForKey(kChoicesTag) as? [AnyObject],
        let choices = YADLJSONParser.loadChoicesFromJSON(choicesParameters)
            else {
                return nil
        }
        
        return choices
    }
    
    var activities: [ActivityStruct]? {
        guard let activitiesParameters = self.json.objectForKey(kActivitiesTag) as? [AnyObject],
            let activities = YADLJSONParser.loadActivitiesFromJSON(activitiesParameters)
            else {
                return nil
        }
        
        return activities
    }
    
    var fullAssessmentSummary: SummaryStruct? {
        guard let summaryParameters = self.json.objectForKey(kFullAssessmentSummaryTag),
            let summary = YADLJSONParser.loadSummaryFromJSON(summaryParameters)
            else {
                return nil
        }
        
        return summary
    }
    
    var spotAssessmentSummary: SummaryStruct? {
        guard let summaryParameters = self.json.objectForKey(kSpotAssessmentSummaryTag),
            let summary = YADLJSONParser.loadSummaryFromJSON(summaryParameters)
            else {
                return nil
        }
        
        return summary
    }
    
    var spotAssessmentOptions: [String: AnyObject]? {
        guard let optionsDictionary = self.json.objectForKey(kSpotAssessmentOptionsTag) as? [String: AnyObject]
            else {
                return nil
        }
        return optionsDictionary
    }
    
    func colorForSpotAssessmentKey(key: String) -> UIColor? {
        if let colorString = self.spotAssessmentOptions?[key] as? String {
            return UIColor(hexString: colorString)
        }
        else { return nil }
    }
    
    var spotAssessmentSubmitButtonColor: UIColor? {
        return self.colorForSpotAssessmentKey(kOptionsSubmitButtonColorTag)
    }
    
    var spotAssessmentNothingToReportButtonColor: UIColor? {
        return self.colorForSpotAssessmentKey(kOptionsNothingToReportButtonColorTag)
    }
    
    var spotAssessmentActivityCellSelectedColor:UIColor? {
        return self.colorForSpotAssessmentKey(kOptionsActivityCellSelectedColorTag)
    }
    
    var spotAssessmentActivityCellSelectedOverlayImage: UIImage? {
        if let imageString = self.spotAssessmentOptions?[kOptionsActivityCellSelectedOverlayImageTitleTag] as? String {
            return UIImage(named: imageString)
        }
        else { return nil }
    }
    
    var spotAssessmentActivityCollectionViewBackgroundColor: UIColor? {
        return self.colorForSpotAssessmentKey(kOptionsActivityCollectionViewBackgroundColorTag)
    }
    
    var spotAssessmentActivitiesPerRow: Int? {
        return self.spotAssessmentOptions?[kOptionsActivitiesPerRowTag] as? Int
    }
    
    var spotAssessmentActivityMinSpacing: CGFloat? {
        return self.spotAssessmentOptions?[kOptionsActivityMinSpacingTag] as? CGFloat
    }

    let json: AnyObject!
    init(json: AnyObject) {
        self.json = json
        super.init()
        
    }
}


