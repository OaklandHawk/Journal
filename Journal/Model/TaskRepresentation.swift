//
//  TaskRepresentation.swift
//  Journal
//
//  Created by Taylor Lyles on 9/18/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
	let title: String
	let bodyText: String
	let timestamp: Date
	let identifier: String
	let mood: String
}
