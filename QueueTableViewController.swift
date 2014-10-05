//
//  QueueTableViewController.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/4/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import UIKit
import AddressBook

class QueueTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

	var authDone = false
	var adbk:ABAddressBook!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
//		println("vdl good to go")
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
				ABAddressBookRequestAccessWithCompletion(adbk) 		{//don't need second param anymore?
					(granted:Bool, err: CFError!) in
					if granted {
						self.adbk = adbk
					} else {
						println(err)
					}
				}
			}
		}
		var errorRef: Unmanaged<CFError>?
		var addressBook: ABAddressBookRef?
		addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
		var contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()

		println("records in the array \(contactList.count)")
		
//		for record:ABRecordRef in contactList {
//			var contactPerson: ABRecordRef = record
//			var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as NSString
//			println("contactName \(contactName)")
//			
//		}

    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)


	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
	
	// UITableViewDelegate
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		performSegueWithIdentifier("showFullList", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//		println("prepare for segue entered")
		if segue.identifier == "showFullList" {
//			println("segue to show all contacts successfully run")
		}
	}
	
	func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
		if let ab = abRef {
			return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
		}
		return nil
	}
	
	
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
