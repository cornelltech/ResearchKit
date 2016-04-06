//
//  YADLFullAssessmentStepViewController.swift
//  ORKCatalog
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchKit.Private

class YADLFullAssessmentQuestionStepViewController: ORKQuestionStepViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(self.step)
//        let customView = YADLFullAssessmentQuestionStepCustomView()
//        self.customQuestionView = customView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func stepDidChange() {
//    
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
