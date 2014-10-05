//
//  ListViewController.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/4/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import UIKit
import AddressBookUI

class ListViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//		let picker = ABPeoplePickerNavigationController()
//		picker.peoplePickerDelegate = self
//		
//	}
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pick", style: .Plain, target: self, action: Selector("didTouchUpInsidePickButton:"))
	}
	
	func didTouchUpInsidePickButton(item: UIBarButtonItem) {
		let picker = ABPeoplePickerNavigationController()
		picker.peoplePickerDelegate = self
		
		if picker.respondsToSelector(Selector("predicateForEnablingPerson")) {
			picker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
		}
		
		presentViewController(picker, animated: true, completion: nil)
	}
	
	func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecordRef!) {
		let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue()
		if (ABMultiValueGetCount(emails) > 0) {
			let index = 0 as CFIndex
			let email = ABMultiValueCopyValueAtIndex(emails, index).takeRetainedValue() as String
			
			println("first email for selected contact = \(email)")
		} else {
			println("No email address")
		}
	}
	
	func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecordRef!) -> Bool {
		
		peoplePickerNavigationController(peoplePicker, didSelectPerson: person)
		
		peoplePicker.dismissViewControllerAnimated(true, completion: nil)
		
		return false;
	}
	
	func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
		peoplePicker.dismissViewControllerAnimated(true, completion: nil)
	}
}
