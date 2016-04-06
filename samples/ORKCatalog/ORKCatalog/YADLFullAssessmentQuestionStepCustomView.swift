//
//  YADLFullAssessmentQuestionStepCustomView.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class YADLFullAssessmentQuestionStepCustomView: ORKQuestionStepCustomView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//        l.text = "Test"
//        self.addSubview(l)
        self.backgroundColor = UIColor.lightGrayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return size
    }
    
    func continueButtonEnabled() -> Bool {
        return false
    }
    
    //this is here due to potential bug at ORKQuestionStepViewController#340
    func cell() -> AnyObject? {
        return nil
    }

}
