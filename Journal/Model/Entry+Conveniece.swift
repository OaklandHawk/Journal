//
//  Entry+Conveniece.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
	
	var entryRepresentation: EntryRepresentation? {
		guard let title = title,
			let bodyText = bodyText,
			let mood = mood,
			let timestamp = timestamp,
			let identifier = identifier else { return nil }
		
		return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
	}
	
	@discardableResult convenience init(title: String, bodyText: String, mood: Mood, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
	
		
		self.init(context: context)
		
		self.title = title
		self.bodyText = bodyText
		self.mood = mood.rawValue
		self.timestamp = timestamp
		self.identifier = identifier
	}
	
	@discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
		
		guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
		
		self.init(title: entryRepresentation.title,
				   bodyText: entryRepresentation.bodyText,
				   mood: mood,
				   timestamp: entryRepresentation.timestamp,
				   identifier: entryRepresentation.identifier,
				   context: context)
	}
}
