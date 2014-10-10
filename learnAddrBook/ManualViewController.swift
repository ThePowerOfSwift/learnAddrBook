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
	var isEdit: Bool = false
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
			
			if contact.firstTime == true {
				contact.hasCalled = false
				contact.firstTime = false
			} else {
				if isEdit == false{
					contact.hasCalled = true
					UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneField.text)"))
				}
			}
			
			var cleanNum: String = contact.phone!.stringByReplacingOccurrencesOfString("[\\(\\)\\-]", withString: "", options: .RegularExpressionSearch)
			var final: String = ""
			var count: Int = 0
			for char in cleanNum {
				if String(char) == "1" || String(char) == "2" || String(char) == "3" || String(char) == "4" || String(char) == "5" || String(char) == "6" || String(char) == "7" || String(char) == "8" || String(char) == "8" || String(char) == "0" {
					final.append(char)
				}
				count++
			}
			phoneField.text = final
			
			appDelegate.saveContext()

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
