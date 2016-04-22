//
//  YADLTextChoice.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/21/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class YADLTextChoice: ORKTextChoice {
    
    var color: UIColor?
    init(text: String, value: protocol<NSCoding, NSCopying, NSObjectProtocol>) {
        super.init(text: text, detailText: nil, value: value, exclusive: false)
    }
    
    convenience init(text: String, value: protocol<NSCoding, NSCopying, NSObjectProtocol>, color: UIColor?) {
        self.init(text: text, value: value)
        self.color = color
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
