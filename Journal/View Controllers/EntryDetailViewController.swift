//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
	
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var segmentControl: UISegmentedControl!
	
	var entry: Entry? {
		didSet {
			updateViews()
		}
	}
	
	var entryController: EntryController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		updateViews()
        // Do any additional setup after loading the view.
    }
	
	func updateViews() {
		if isViewLoaded == true {
		title = entry?.title ?? "Create Entry"
		
		textField.text = entry?.title
		textView.text = entry?.bodyText
		}
	}
    
	@IBAction func save(_ sender: Any) {
		guard let title = textField.text,
			let bodyText = textView.text,
			!title.isEmpty else { return }
		
		
	if let entry = entry {
		entryController?.updateEntry(entry: entry, with: title, bodyText: bodyText)
		} else {
		entryController?.create(with: title, bodyText: bodyText)
		}
		navigationController?.popViewController(animated: true)
	}
}
