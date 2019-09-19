//
//  CoreDataStack.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
	
	static let shared = CoreDataStack()
	
	private init() {
	
	}
	
	lazy var container: NSPersistentContainer = {
		
		let container = NSPersistentContainer(name: "Entry")
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		})
		return container
	}()
	
	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
	
	func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		context.performAndWait {
			do {
				try context.save()
			} catch {
				NSLog("Error saving context: \(error)")
				context.reset()
			}
		}
	}
}
