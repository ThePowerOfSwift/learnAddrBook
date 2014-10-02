//
//  ViewController.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/2/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import UIKit
import AddressBook

class ViewController: UIViewController {
	var authDone = false
	var adbk:ABAddressBook!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		if !authDone {
			authDone = true
			let stat = ABAddressBookGetAuthorizationStatus()
			switch stat {
			case .Denied, .Restricted:
				println("no access")
			case .Authorized, .NotDetermined:
				var err:Unmanaged<CFErrorRef>? = nil
				var adbk: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
				if adbk == nil {
					println(err)
					return
				}
				ABAddressBookRequestAccessWithCompletion(adbk) {//don't need second param anymore?
					(granted:Bool, err: CFError!) in
					if granted {
						self.adbk = adbk
					} else {
						println(err)
					}
				}
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func loadContactsPressed(sender: UIButton) {
		var newContact:ABAddressBookRef! = ABPersonCreate().takeRetainedValue()
		var success:Bool = false
		var newFirstName:String = "Stanley"
		var newLastName:String = "Chiang"
		
		success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, newFirstName, nil)
		println("first name? \(success)")
		success = ABRecordSetValue(newContact, kABPersonLastNameProperty, newLastName, nil)
		println("last name? \(success)")
		success = ABAddressBookAddRecord(adbk, newContact, nil)
		println("addr book? \(success)")
		success = ABAddressBookSave(adbk, nil)
		println("first name? \(success)")
	}

	@IBAction func printPressed(sender: UIButton) {
		var errorRef: Unmanaged<CFError>?
		var addressBook: ABAddressBookRef?
		addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
		var contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
		println("records in the array \(contactList.count)")
		
		for record:ABRecordRef in contactList {
			var contactPerson: ABRecordRef = record
			var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as NSString
			println("contactName \(contactName)")
			
		}
	}
	
	func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
		if let ab = abRef {
			return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
		}
		return nil
	}
	
}





