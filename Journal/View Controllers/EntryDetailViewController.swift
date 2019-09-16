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
		title = entry?.title ?? "Create Entry"
		textField.text = entry?.title
		textView.text = entry?.bodyText
	}
    
	@IBAction func save(_ sender: Any) {
		guard let title = textField.text,
			let bodyText = textView.text else { return }
		
		
		if entry != nil {
			guard let thisEntry = entry else { return }
			
			entryController?.updateEntry(entry: thisEntry, with: title, bodyText: bodyText, timestamp: CVTimeStamp)
			navigationController?.popViewController(animated: true)
		} else {
			entryController?.createEntry(
			navigationController?.popViewController(animated: true)
		}
	}
	
}
