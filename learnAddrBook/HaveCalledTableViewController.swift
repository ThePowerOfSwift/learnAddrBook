//
//  HaveCalledTableViewController.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/7/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import UIKit
import CoreData

class HaveCalledTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
	var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		fetchedResultsController = getFetchResultsController()
		fetchedResultsController.delegate = self
		fetchedResultsController.performFetch(nil)
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "undo" {
			let destVC: QueueTableViewController = segue.destinationViewController as QueueTableViewController
			
		}
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
		var cell: ModTableViewCell = tableView.dequeueReusableCellWithIdentifier("modCell") as ModTableViewCell
		cell.nameLabel.text = theContact.name
		cell.memoLabel.text = theContact.memo
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
		let undoAction = UITableViewRowAction(style: .Normal, title: "undo", handler: {
			(action, indexPath) -> Void in
			let theContact:Contacts = self.fetchedResultsController.objectAtIndexPath(indexPath) as Contacts
			theContact.hasCalled = false
			}
		)
		undoAction.backgroundColor = UIColor.blueColor()
		let deleteAction = UITableViewRowAction(style: .Normal, title: "delete", handler: {
			(action, indexPath) -> Void in
			self.tableView(self.tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
			}
		)
		//buttons get displayed in backwards order in app
		return [deleteAction, undoAction]
		}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			let managedObject: NSManagedObject = fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
			managedObjectContext.deleteObject(managedObject)
			(UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
		}

	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.reloadData()
	}
	
	func contactFetchRequest() -> NSFetchRequest {
		let fetchRequest = NSFetchRequest(entityName: "Contacts")
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchRequest.predicate = NSPredicate(format: "hasCalled = true")
		return fetchRequest
	}
	
	
	func getFetchResultsController() -> NSFetchedResultsController {
		fetchedResultsController = NSFetchedResultsController(fetchRequest: contactFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return fetchedResultsController
	}

}
