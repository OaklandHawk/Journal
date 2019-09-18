//
//  EntryTableViewController.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewController: UITableViewController {
	
	let baseURL = URL(string: "https://journ-6bde1.firebaseio.com/")!
	
	let entryController = EntryController()
	
	var count = 0
	
	lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
		
		let fetchedRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		fetchedRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: true)]
		
		let frc = NSFetchedResultsController(fetchRequest: fetchedRequest,
											 managedObjectContext: CoreDataStack.shared.mainContext,
											 sectionNameKeyPath: "mood",
											 cacheName: nil)
		
		count += 1
		
		frc.delegate = self
		
		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		
		return frc
		
	}()
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as! EntryTableViewCell

		let entry = fetchedResultsController.object(at: indexPath)
		
		cell.entry = entry
		cell.updateViews()
		

        return cell
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
		
		return sectionInfo.name.capitalized
		
	}

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			let entry = fetchedResultsController.object(at: indexPath)
			entryController.deleteEntry(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddShowToDetailSegue" {
			guard let newEntryVC = segue.destination as? EntryDetailViewController else { return }

			newEntryVC.entryController = entryController
		} else {
			guard let selectedEntryVC = segue.destination as? EntryDetailViewController,
				let indexPath = tableView.indexPathForSelectedRow else { return }
			let entry = fetchedResultsController.object(at: indexPath)

			selectedEntryVC.entry = entry
			selectedEntryVC.entryController = entryController
		}
    }

}

extension EntryTableViewController: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		@unknown default:
			return
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {
		
		let sectionsSet = IndexSet(integer: sectionIndex)
		
		switch type {
		case .insert:
			tableView.insertSections(sectionsSet, with: .automatic)
		case .delete:
			tableView.deleteSections(sectionsSet, with: .automatic)
		default:
			return
		}
	}
}
