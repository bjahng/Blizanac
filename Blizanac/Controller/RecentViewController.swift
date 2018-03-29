//
//  RecentViewController.swift
//  Blizanac
//
//  Created by admin on 3/20/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    var matchList: Results<Match>?
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
    
    // MARK: - tableView Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchList?.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        
        if let match = matchList?[indexPath.row] {
            cell.textLabel?.text = match.title
            cell.detailTextLabel?.text = match.dateCreated?.toString()
            
            if let color = UIColor(hexString: match.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(matchList!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.detailTextLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
                let backgroundView = UIView()
                backgroundView.backgroundColor = color
                cell.selectedBackgroundView = backgroundView
            }
        }
        return cell
    }
    
    //  MARK: - tableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // give time to show activity indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performSegue(withIdentifier: "goToResultsViewFromRecent", sender: self)
        }
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            deleteItem(indexPath: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResultsViewFromRecent" {
            let destinationVC = segue.destination as? ResultsViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let fileName = self.matchList?[indexPath.row].dateCreated?.toString()
                let fileURL = self.documentsDirectory.appendingPathComponent(fileName!)
                if let image = UIImage(contentsOfFile: fileURL.path) {
                    destinationVC?.selectedPic = image
                    destinationVC?.fromRecent = true
                } else {
                    activityIndicator.stopAnimating()
                    deleteItem(indexPath: indexPath)
                    displayAlert("Can't find file at path!\r\nDeleting item.")
                }
            }
        }
    }
    
    func deleteItem(indexPath: IndexPath) {
        
        // Delete image from documents directory
        let fileName = matchList?[indexPath.row].dateCreated?.toString()
        let fileURL = documentsDirectory.appendingPathComponent(fileName!)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                displayAlert("Error deleting file")
            }
        }
        
        // Delete from Realm
        if let itemForDeletion = self.matchList?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                displayAlert("Error deleting item")
            }
        }
        tableView.reloadData()
    }
    
}
