//
//  ManualViewController.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/6/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {
	var rstring: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		println("rstring: \(rstring!)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
