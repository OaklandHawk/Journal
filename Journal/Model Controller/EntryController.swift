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
	
	let baseURL = URL(string: "https://journ-6bde1.firebaseio.com/")!

	func put(entry: Entry, completion: @escaping () -> Void = { }) {
		
		let identifier = entry.identifier ?? UUID()
		entry.identifier = identifier
		
		let requestURL = baseURL
			.appendingPathComponent(identifier.uuidString)
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
		
		}
	
}
