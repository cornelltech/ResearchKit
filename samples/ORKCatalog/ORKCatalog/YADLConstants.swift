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

