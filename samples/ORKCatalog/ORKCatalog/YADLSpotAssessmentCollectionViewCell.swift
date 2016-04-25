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
    var selectedBackgroundColor: UIColor = UIColor.blueColor() {
        didSet {
            if self.selected {
                self.backgroundColor = selectedBackgroundColor
            }
            else {
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    var activityImage: UIImage? {
        willSet(newActivityImage) {
            self.activityImageView.layer.borderWidth = 1
            self.activityImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.activityImageView.image = newActivityImage
        }
    }
    
    var selectedOverlayImage: UIImage? {
        willSet(newSelectedOverlayImage) {
            self.checkImageView.image = newSelectedOverlayImage
        }
    }
    
    override var selected: Bool {
        didSet {
            if selected {
                self.backgroundColor = self.selectedBackgroundColor
            }
            else {
                self.backgroundColor = UIColor.clearColor()
            }
            
            self.checkImageView.hidden = !selected
            
        }
    }
    
}
