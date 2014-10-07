//
//  ContactModel.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/6/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import Foundation
import CoreData

@objc(ContactModel)
class ContactModel: NSManagedObject {

    @NSManaged var name: String

}
