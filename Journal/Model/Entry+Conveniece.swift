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
	
	@discardableResult convenience init(title: String, bodyText: String, context: NSManagedObjectContext) {
	
		
		self.init(context: context)
		
		self.title = title
		self.bodyText = bodyText
//		self.timestamp = timestamp
//		self.identifier = identifier
	}
	
}
