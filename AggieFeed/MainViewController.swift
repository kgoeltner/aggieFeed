//
//  MainViewController.swift
//  AggieFeed
//
//  Created by Karl Goeltner on 9/2/20.
//  Copyright © 2020 Karl Goeltner. All rights reserved.
//

import CoreData
import UIKit
import SwiftyJSON

class MainViewController: UITableViewController {
    
    // MARK: Properties
    
    let feedURL = "https://aggiefeed.ucdavis.edu/api/v1/activity/public?s=0&l=25"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var activitiesCache = [`Activity`]()
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        performRequest()
    }

    // MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesCache.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        
        let activity = activitiesCache[indexPath.row]
        
        cell.titleLabel?.text = activity.title
        cell.displayNameLabel?.text = activity.displayName
        
        return cell
    }
    
    // MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)*/
    }
    
    // MARK: REST API Methods

    func performRequest() {
        if let url = URL(string: feedURL) {
            let session = URLSession(configuration: .default)
            
            // Establish task to parse JSON or pull data from cache
            let task = session.dataTask(with: url) { (data, response, error) in
                // ERROR obtaining JSON
                if error != nil {
                    self.loadCache()
                    print(error!)
                }
                
                // SUCCESS parse JSON
                if let safeData = data {
                    // Remove old cache
                    self.loadCache()
                    self.deleteCache()
                    
                    self.parseJSON(activityData: safeData)
                }
                
                // Reload tableView contents
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(activityData: Data) {
        do {
            let json = try JSON(data: activityData)
            var cnt = 0
            
            // Create new Activities w/ attributes
            for activity in json.arrayValue {
                let newActivity = Activity(context: self.context)
                
                newActivity.index = Int32(cnt)
                newActivity.title = activity["title"].string
                newActivity.displayName = activity["actor"]["displayName"].string
                newActivity.objectType = activity["object"]["objectType"].string
                newActivity.published = activity["published"].string
                                
                activitiesCache.append(newActivity)
                cnt += 1
            }
            
            saveContext()
        } catch {
            print(error)
        }
    }

    // MARK: Model Manipulation Methods
    
    func loadCache() {
        let request : NSFetchRequest<Activity> = Activity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
            
        do {
            activitiesCache = try context.fetch(request)
        } catch {
            print("Error loading activities \(error)")
        }
    }
    
    func deleteCache() {
        for activity in activitiesCache {
            context.delete(activity)
        }
        
        activitiesCache.removeAll()
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
}

