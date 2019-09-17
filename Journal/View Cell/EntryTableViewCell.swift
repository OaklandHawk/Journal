//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var bodyText: UILabel!
	@IBOutlet weak var timestamp: UILabel!
	
	var entry: Entry? {
		didSet {
			updateViews()
		}
	}

	
	func updateViews() {
//		guard let timestamp = entry?.timestamp else { return }
		
		title.text = entry?.title
		bodyText.text = entry?.bodyText
//		timestamp.text = "\(timestamp)"
	}
}
