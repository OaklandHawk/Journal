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
	
}
