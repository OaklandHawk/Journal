//
//  EntryTableViewController.swift
//  Journal
//
//  Created by Taylor Lyles on 9/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {
	
	let entryController = EntryController()
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
	
	// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as! EntryTableViewCell

		cell.textLabel?.text = entryController.entries[indexPath.row].title

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
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
			selectedEntryVC.entry = entryController.entries[indexPath.row]
			selectedEntryVC.entryController = entryController
		}
    }

}
