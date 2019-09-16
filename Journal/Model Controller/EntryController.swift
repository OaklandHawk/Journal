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
	
//	func saveToPersistentStore() {
//		do {
//			try mainContext.save()
//		} catch {
//			NSLog("Error saving context: \(error)")
//			mainContext.reset()
//		}
//	}
	
	var entries: [Entry] {
		
		loadFromPersistenStore()
		return loadFromPersistenStore()
	}
	
	
	func loadFromPersistenStore() -> [Entry] {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		
		do {
			let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
			return entries
		} catch {
			NSLog("Error fetching tasks: \(error)")
			return []
		}
	}
	
	@discardableResult func create(with title: String, bodyText: String, timestamp: Date, identifier: String) -> Entry {
		
		let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, indentifier: identifier, context: CoreDataStack.shared.mainContext)
		
		CoreDataStack.shared.saveToPersistentStore()

		return entry
	}
	
	func updateEntry(entry: Entry, with title: String, bodyText: String, timestamp: Date, identifier: String) {
		
		entry.title = title
		entry.bodyText = bodyText
		entry.timestamp = timestamp
		entry.identifier = identifier
		
		CoreDataStack.shared.saveToPersistentStore()
	}
	
	func deleteEntry(entry: Entry) {
		
		CoreDataStack.shared.mainContext.delete(entry)
		CoreDataStack.shared.saveToPersistentStore()
	}
	
}
