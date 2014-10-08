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
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var phoneField: UITextField!
	@IBOutlet weak var memoField: UITextField!
	@IBOutlet weak var datePicker: UIDatePicker!
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
	
	override func viewDidLoad() {
        super.viewDidLoad()
		println(contact.name)
		if isNew! {//newly added from textfield
			nameField.text = rstring!
		} else if contact.phone? == nil  || contact.phone? == Optional(""){//added from AB, need to take directly here later on
				nameField.text = contact.name
				memoField.text = contact.memo
				phoneField.text = contact.phone
		} else {//dial out
			nameField.text = contact.name
			memoField.text = contact.memo
			phoneField.text = contact.phone

			UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(contact.phone!)"))
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
		contact.memo = memoField.text
		contact.phone = phoneField.text
		
		appDelegate.saveContext()
	}
	
	func editContact() {
		let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)

		contact.name = nameField.text
		contact.memo = memoField.text
		contact.phone = phoneField.text

		appDelegate.saveContext()
	}
}
