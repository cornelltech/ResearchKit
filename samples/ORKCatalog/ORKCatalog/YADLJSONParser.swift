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

let kFullAssessmentTag = "full"
let kSpotAssessmentTag = "spot"

let kPromptTag = "prompt"
let kIdentifierTag = "identifier"

let kChoicesTag = "choices"
let kChoiceTextTag = "text"
let kChoiceValueTag = "value"
let kChoiceColorTag = "color"

let kActivitiesTag = "activities"
let kActivityImageTitleTag = "imageTitle"
let kActivityDescriptionTag = "description"
let kActivityIdentifierTag = "identifier"

let kSummaryTag = "summary"
let kSummaryTitleTag = "title"
let kSummaryTextTag = "text"

let kOptionsTag = "options"
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
    
    var fullAssessment: [String: AnyObject]? {
        return self.json.objectForKey(kFullAssessmentTag) as? [String: AnyObject]
    }
    
    var fullAssessmentPrompt: String? {
        return self.fullAssessment?[kPromptTag] as? String
    }
    
    var fullAssessmentIdentifier: String? {
        return self.fullAssessment?[kIdentifierTag] as? String
    }
    
    var fullAssessmentSummary: SummaryStruct? {
        guard let summaryParameters = self.fullAssessment?[kSummaryTag]
            else {
                return nil
        }
        
        return YADLJSONParser.loadSummaryFromJSON(summaryParameters)
    }
    
    var spotAssessment: [String: AnyObject]? {
        return self.json.objectForKey(kSpotAssessmentTag) as? [String: AnyObject]
    }
    
    var spotAssessmentPrompt: String? {
        return self.spotAssessment?[kPromptTag] as? String
    }
    
    var spotAssessmentIdentifier: String? {
        return self.spotAssessment?[kIdentifierTag] as? String
    }
    
    var spotAssessmentSummary: SummaryStruct? {
        guard let summaryParameters = self.spotAssessment?[kSummaryTag]
            else {
                return nil
        }
        
        return YADLJSONParser.loadSummaryFromJSON(summaryParameters)
    }
    
    var fullAssessmentChoices: [ChoiceStruct]? {
        guard let choicesParameters = self.fullAssessment?[kChoicesTag] as? [AnyObject]
            else {
                return nil
        }
        
        return YADLJSONParser.loadChoicesFromJSON(choicesParameters)
    }
    
    var activities: [ActivityStruct]? {
        guard let activitiesParameters = self.json.objectForKey(kActivitiesTag) as? [AnyObject]
            else {
                return nil
        }
        
        return YADLJSONParser.loadActivitiesFromJSON(activitiesParameters)
    }
    
    var spotAssessmentOptions: [String: AnyObject]? {
        return self.spotAssessment?[kOptionsTag] as? [String: AnyObject]
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


