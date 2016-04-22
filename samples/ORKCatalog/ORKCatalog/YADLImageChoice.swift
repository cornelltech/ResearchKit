//
//  YADLImageChoice.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/22/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit

class YADLImageChoice: NSObject, NSSecureCoding, NSCopying {
    
    var value: protocol<NSCoding, NSCopying, NSObjectProtocol>
    var image: UIImage
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.value, forKey: "value")
        aCoder.encodeObject(self.image, forKey: "image")
        
    }
    
    init(image: UIImage, value: protocol<NSCoding, NSCopying, NSObjectProtocol>) {
        self.image = image
        self.value = value
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let value = aDecoder.decodeObjectForKey("value") as? protocol<NSCoding, NSCopying, NSObjectProtocol>,
            let image = aDecoder.decodeObjectOfClass(UIImage.self, forKey: "image")
            else { return nil }
        
        self.init(image: image, value: value)
        
    }
    
    class func supportsSecureCoding() -> Bool {
        return false
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = YADLImageChoice(image: self.image, value: self.value)
        return copy
    }
    

}
