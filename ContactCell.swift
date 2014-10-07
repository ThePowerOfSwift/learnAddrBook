//
//  ContactCell.swift
//  learnAddrBook
//
//  Created by Stanley Chiang on 10/4/14.
//  Copyright (c) 2014 Stanley Chiang. All rights reserved.
//

import Foundation
import UIKit

class ContactCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var memoLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}