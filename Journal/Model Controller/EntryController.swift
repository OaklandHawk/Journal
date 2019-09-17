//
//  EntryController.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
	
	@discardableResult func create(with title: String, bodyText: String, mood: Mood) -> Entry {
		
		let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
		
		CoreDataStack.shared.saveToPersistentStore()
		
		return entry
	}
	
	func updateEntry(entry: Entry, with title: String, bodyText: String, mood: String) {
		
		entry.title = title
		entry.bodyText = bodyText
		entry.mood = mood
		
		CoreDataStack.shared.saveToPersistentStore()
	}
	
	func deleteEntry(entry: Entry) {
		
		CoreDataStack.shared.mainContext.delete(entry)
		CoreDataStack.shared.saveToPersistentStore()
	}
	
}
