//
//  DetailViewController.swift
//  AggieFeed
//
//  Created by Karl Goeltner on 9/2/20.
//  Copyright © 2020 Karl Goeltner. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var selectedActivity : Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell

        if let act = selectedActivity {
            cell.titleLabel?.text = act.title
            cell.displayNameLabel?.text = act.displayName
            cell.objectTypeLabel?.text = act.objectType
            cell.publishedLabel?.text = act.published
        } else {
            cell.titleLabel?.text = "No Items Added"
            cell.displayNameLabel?.text = ""
            cell.objectTypeLabel?.text = ""
            cell.publishedLabel?.text = ""
        }
        
        return cell
    }
}
