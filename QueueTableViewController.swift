//
//  QueueTableViewController.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/4/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import UIKit
import AddressBookUI
import CoreData

class QueueTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, ABPeoplePickerNavigationControllerDelegate, NSFetchedResultsControllerDelegate {

	var contact: ABMultiValueRef!
	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
	var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
	var person: Contacts!
	@IBOutlet weak var textField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		fetchedResultsController = getFetchResultsController()
		fetchedResultsController.delegate = self
		fetchedResultsController.performFetch(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if segue.identifier == "showAddManual" {
			let destVC: ManualViewController = segue.destinationViewController as ManualViewController
			destVC.rstring = textField.text
			destVC.isNew = true
		} else if segue.identifier == "showEdit" {
			let destVC: ManualViewController = segue.destinationViewController as ManualViewController
			destVC.isNew = false
			let indexPath = tableView.indexPathForSelectedRow()
			if indexPath? == nil {
				destVC.contact = person
			} else {
				let cell = fetchedResultsController.objectAtIndexPath(indexPath!) as Contacts
				destVC.contact = cell
			}
		}
		else if segue.identifier == "callNow" {
			let CallVC: CallViewController = segue.destinationViewController as CallViewController
		}
	}
	
	@IBAction func addManuallyPressed(sender: UIButton) {
	}
    // MARK: - Table view data source
	
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		let numberOfSections = fetchedResultsController.sections?.count
		return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRowsInSection = fetchedResultsController.sections![section].numberOfObjects
		return numberOfRowsInSection!
	}

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let theContact = fetchedResultsController.objectAtIndexPath(indexPath) as Contacts
		
		var cell: ContactCell = tableView.dequeueReusableCellWithIdentifier("listCell") as ContactCell
		cell.nameLabel.text = theContact.name
		cell.memoLabel.text = theContact.memo
        return cell
    }
	
	@IBAction func call(sender: UIBarButtonItem) {
		performSegueWithIdentifier("callNow", sender: self)
	}

	@IBAction func addToQueuePressed(sender: UIBarButtonItem) {
		let picker = ABPeoplePickerNavigationController()
		picker.peoplePickerDelegate = self
		presentViewController(picker, animated: true, completion: nil)
	}

	func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecordRef!) {
		contact = ABRecordCopyCompositeName(person).takeRetainedValue()
		let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
		let entityDescription = NSEntityDescription.entityForName("Contacts", inManagedObjectContext: managedObjectContext)
		var person = Contacts(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext) as Contacts
		person.name = contact as String
		self.person = person
		appDelegate.saveContext()   //what is the difference between this line and the one below ???
		//managedObjectContext.save(nil)
		performSegueWithIdentifier("showEdit", sender: self)
	}
	
	func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecordRef!) -> Bool {
		peoplePickerNavigationController(peoplePicker, didSelectPerson: person)
		peoplePicker.dismissViewControllerAnimated(true, completion: nil)
		
		return false;
	}
	
	func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
		peoplePicker.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.reloadData()
	}

	func contactFetchRequest() -> NSFetchRequest {
		let fetchRequest = NSFetchRequest(entityName: "Contacts")
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		return fetchRequest
	}

	
	func getFetchResultsController() -> NSFetchedResultsController {
		fetchedResultsController = NSFetchedResultsController(fetchRequest: contactFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return fetchedResultsController
	}
	
}
