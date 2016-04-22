//
//  YADLSpotAssessmentCollectionViewCell.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/22/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit

class YADLSpotAssessmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    var activityImage: UIImage? {
        willSet(newActivityImage) {
            self.activityImageView.image = newActivityImage
        }
    }
    
    override var selected: Bool {
        didSet {
            if selected {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.blueColor().CGColor
            }
            else {
                self.layer.borderWidth = 0
            }
            
            self.checkImageView.hidden = !selected
            
        }
    }
    
}
