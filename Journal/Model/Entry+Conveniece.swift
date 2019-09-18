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
	
	@discardableResult convenience init(title: String, bodyText: String, mood: Mood, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext) {
	
		
		self.init(context: context)
		
		self.title = title
		self.bodyText = bodyText
		self.mood = mood.rawValue
		self.timestamp = timestamp
//		self.identifier = identifier
	}
	
	@discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
		
		guard let identifier = UUID(uuidString: entryRepresentation.identifier),
			let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
		
		self.init(title: entryRepresentation.title,
				   bodyText: entryRepresentation.bodyText,
				   mood: mood,
				   timestamp: entryRepresentation.timestamp,
				   identifier: identifier,
				   context: context)
		
	}
	
}
