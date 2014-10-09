//
//  ManualViewController.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/6/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import UIKit
import CoreData
//should really be called detailvc
class ManualViewController: UIViewController {
	var rstring: String?
	var isNew: Bool?
	var contact: Contacts!
	var cleanNum: String = ""
	
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var phoneField: UITextField!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var datePicker: UIDatePicker!
	
	let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)

	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
	
	override func viewDidLoad() {
        super.viewDidLoad()

		if isNew! {//newly added from textfield
			nameField.text = rstring!

		} else if contact.phone? == nil  || contact.phone? == Optional(""){
				nameField.text = contact.name
				textView.text = contact.memo
				phoneField.text = contact.phone
				contact.firstTime = false
		} else {//dial out
			nameField.text = contact.name
			textView.text = contact.memo
			phoneField.text = contact.phone

			appDelegate.saveContext()
			if contact.firstTime == true {
				contact.hasCalled = false
				contact.firstTime = false
			} else {
				contact.hasCalled = true
				cleanNum = contact.phone!.stringByReplacingOccurrencesOfString("(", withString: "", options: nil, range: nil)
				cleanNum = contact.phone!.stringByReplacingOccurrencesOfString(")", withString: "", options: nil, range: nil)
				cleanNum = contact.phone!.stringByReplacingOccurrencesOfString("-", withString: "", options: nil, range: nil)
//				cleanNum = contact.phone!.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
				println("dialing...\(cleanNum)")
				UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(cleanNum)"))
			}
		}
    }

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func donePressed(sender: UIBarButtonItem) {
		if isNew! {
			addContact()
		} else {
			editContact()
		}
		self.navigationController?.popToRootViewControllerAnimated(true)
	}

	func addContact() {
		let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)

		let entityDescription = NSEntityDescription.entityForName("Contacts", inManagedObjectContext: managedObjectContext!)
		let contact = Contacts(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
		
		contact.name = nameField.text
		contact.memo = textView.text
		contact.phone = phoneField.text
		
		appDelegate.saveContext()
	}
	
	func editContact() {
		let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)

		contact.name = nameField.text
		contact.memo = textView.text
		contact.phone = phoneField.text
		contact.firstTime = false
		appDelegate.saveContext()
	}
}
