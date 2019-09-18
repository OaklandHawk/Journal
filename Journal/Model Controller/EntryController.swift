//
//  EntryController.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}

class EntryController {
	
	init() {
		fetchEntriesFromServer()
	}
	
	let baseURL = URL(string: "https://journ-6bde1.firebaseio.com/")!

	func put(entry: Entry, completion: @escaping () -> Void = { }) {
		
		let identifier = entry.identifier
		entry.identifier = identifier
		
		let requestURL = baseURL
			.appendingPathComponent("identifier")
			.appendingPathExtension("json")
		
		
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.put.rawValue
		
		guard let entryRepresentation = entry.entryRepresentation else {
			NSLog("Entry Representation is nil")
			completion()
			return
		}
		
		do {
			request.httpBody = try JSONEncoder().encode(entryRepresentation)
		} catch {
			NSLog("Error encoding entry representation: \(error)")
			completion()
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_, _, error) in
			if let error = error {
				NSLog("Error PUTing entry: \(error)")
				completion()
				return
			}
		}
	}
	
	// TODO: updateFunction
	func update(entry: Entry, representation: EntryRepresentation) {
		
	}
	
	func updateEntries(with representations: [EntryRepresentation]) {
		let identifiersToFetch = representations.compactMap({$0.identifier})
		
		let representationsById = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
		
		var tasksToCreate = representationsById
		
		do {
			let context = CoreDataStack.shared.mainContext
			
			let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
			
			// identifier == \(identifier)
			fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
			
			// Which of these tasks exsist in Core Data already?
			let exsistingTask = try context.fetch(fetchRequest)
			
			// Which need to be updated? Which need to be put into Core Data?
			for entry in exsistingTask {
				guard let identifier = entry.identifier,
					// This gets the task representation that corresponds to the task from Core Data.
					let representation = representationsById[identifier] else { continue }
				
				entry.title = representation.title
				entry.bodyText = representation.bodyText
				entry.mood = representation.mood
				
				tasksToCreate.removeValue(forKey: identifier)
			}
			
			// Take the task that AREN'T in Core Data and create new ones for them.
			for represntation in tasksToCreate.values {
				Entry(entryRepresentation: represntation, context: context)
			}
			
			CoreDataStack.shared.saveToPersistentStore()
			
		} catch {
			NSLog("Error fetching entry from persistent store: \(error)")
		}
	}
	
	func fetchEntriesFromServer(completion: @escaping () -> Void = { }) {
		
		// appendingPathComponent adds a '/'
		// appendingPathExtension adds a '.'
		
		let requestURL = baseURL.appendingPathExtension("json")
		
		URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
			
			if let error = error {
				NSLog("Error fetching tasks: \(error)")
				completion()
			}
			
			guard let data = data else {
				NSLog("No data returned from data task")
				completion()
				return
			}
			
			do {
				let decoder = JSONDecoder()
				
				let entryRepresentations = try decoder.decode([String: EntryRepresentation].self, from: data).map({ $0.value })
				
				self.updateEntries(with: entryRepresentations)
				
			} catch {
				NSLog("Error decoding: \(error)")
			}
		}.resume()
	}
	
	@discardableResult func create(with title: String, bodyText: String, mood: Mood) -> Entry {
		
		let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
		
		CoreDataStack.shared.saveToPersistentStore()
		
		put(entry: entry)
		
		return entry
	}
	
	func updateEntry(entry: Entry, with title: String, bodyText: String, mood: String) {
		
		entry.title = title
		entry.bodyText = bodyText
		entry.mood = mood
		
		CoreDataStack.shared.saveToPersistentStore()
		
		put(entry: entry)
	}
	
	func deleteEntry(entry: Entry) {
		
		CoreDataStack.shared.mainContext.delete(entry)
		CoreDataStack.shared.saveToPersistentStore()
		deleteEntryFromServer(entry: entry)
	}
	
	// TODO: Add optional Error
	func deleteEntryFromServer(entry: Entry, completion: @escaping () -> Void = { }) {
		let requestURL = baseURL.appendingPathExtension("json")
		
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.delete.rawValue
		
		URLSession.shared.dataTask(with: request) { (_, _, error) in
			if let error = error {
				NSLog("Error deleting entry: \(error)")
				completion()
				return
				}
			}
		}
}
