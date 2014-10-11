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
	var isEdit: Bool?
	var contact: Contacts!
	var cleanNum: String = ""
	var caseNum: Int!
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var phoneField: UITextField!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var datePicker: UIDatePicker!
		
	let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)

	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
	
	override func viewDidLoad() {
        super.viewDidLoad()
		println(isEdit!)

		if isNew! {
			caseNum = 1
		} else if let phone = contact.phone?  {
			phoneField.text = cleaner(phone)
			if phone != "" {
				if contact.firstTime == true {
					caseNum = 2
				} else {
					if isEdit == false{
						caseNum = 0
					} else {
						caseNum = 3
					}
				}

			} else {
				caseNum = 3
			}
		} else {
			caseNum = 3
		}
		
		switch caseNum {
		case 1:
			println("case1:--manually added")
			nameField.text = rstring!
			phoneField.text = ""
			textView.text = ""
		case 2:
			println("case2:--loaded directly from AB")
			nameField.text = contact.name
//			phoneField.text = phone
			textView.text = contact.memo
			contact.firstTime = false
			contact.hasCalled = false
		case 3:
			println("case3:--edit")
			nameField.text = contact.name
			textView.text = contact.memo
//			phoneField.text = contact.phone
			contact.firstTime = false
			contact.hasCalled = false
		default:
			println("dial out")
			nameField.text = contact.name
			textView.text = contact.memo
			contact.firstTime = false
			contact.hasCalled = true
			UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneField.text)"))
		}
		appDelegate.saveContext()
	}
	func cleaner(phNum: String) -> String {
		var cleaned = phNum.stringByReplacingOccurrencesOfString("[\\(\\)\\-]", withString: "", options: .RegularExpressionSearch)
		var final: String = ""
		var count: Int = 0
		for char in cleaned {
			if String(char) == "1" || String(char) == "2" || String(char) == "3" || String(char) == "4" || String(char) == "5" || String(char) == "6" || String(char) == "7" || String(char) == "8" || String(char) == "8" || String(char) == "0" {
				final.append(char)
			}
			count++
		}
		return final
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
/*
if isNew! {//newly added from textfield
nameField.text = rstring!//case1
println("manually added")
} else if let phone = contact.phone?  {
if phone != "" {
//phone is present
nameField.text = contact.name
textView.text = contact.memo

if contact.firstTime == true {
contact.hasCalled = false//case2
println("loaded directly from AB")
contact.firstTime = false
} else {
if isEdit == false{
contact.hasCalled = true
println("dial out")
UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneField.text)"))//case5
} else {
nameField.text = contact.name
textView.text = contact.memo//case4
println("arbitrary edit")
contact.firstTime = false
}
}
cleanNum = phone.stringByReplacingOccurrencesOfString("[\\(\\)\\-]", withString: "", options: .RegularExpressionSearch)
var final: String = ""
var count: Int = 0
for char in cleanNum {
if String(char) == "1" || String(char) == "2" || String(char) == "3" || String(char) == "4" || String(char) == "5" || String(char) == "6" || String(char) == "7" || String(char) == "8" || String(char) == "8" || String(char) == "0" {
final.append(char)
}
count++
}
phoneField.text = final
} else {
nameField.text = contact.name
textView.text = contact.memo
phoneField.text = ""//contact.phone//case3
println("edit w/ no num")
contact.firstTime = false
}
} else {
nameField.text = contact.name
textView.text = contact.memo
phoneField.text = ""//contact.phone//case3
println("edit w/ no num")
contact.firstTime = false
}
appDelegate.saveContext()
*/
