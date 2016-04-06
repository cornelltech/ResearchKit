//
//  YADLFullAssessmentQuestionStepViewController.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/4/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class YADLFullAssessmentStepViewController: ORKStepViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        l.text = "Test"
        self.view.addSubview(l)
        
        print(self.step)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func hasNextStep() -> Bool {
        return true
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
