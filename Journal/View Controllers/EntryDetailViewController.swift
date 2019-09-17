//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit
import CoreData


enum Mood: String, CaseIterable {
	case happy
	case silly
	case deepThought
	
//	func indexValue() -> Int {
//		switch self {
//		case .happy:
//			return 0
//		case .silly:
//			return 1
//		case .deepThought:
//			return 2
//		}
//	}
//
	static var value: [Mood] {
		return [.happy, .silly, .deepThought]
	}
}

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
			
		if let currentMood = entry?.mood,
			let mood = Mood(rawValue: currentMood) {
			
			let index = Mood.allCases.firstIndex(of: mood) ?? 0
			
			segmentControl.selectedSegmentIndex = index
			}
			
		}
	}
    
	@IBAction func save(_ sender: Any) {
		guard let title = textField.text,
			let bodyText = textView.text,
			!title.isEmpty else { return }
		
		let moodIndex = segmentControl.selectedSegmentIndex
		
		let mood = Mood.allCases[moodIndex]
		
		
	if let entry = entry {
		entryController?.updateEntry(entry: entry, with: title, bodyText: bodyText, mood: mood.rawValue)
		} else {
		entryController?.create(with: title, bodyText: bodyText, mood: mood)
		}
		navigationController?.popViewController(animated: true)
	}
}
