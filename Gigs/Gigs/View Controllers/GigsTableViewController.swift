//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Cody Morley on 5/5/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    //MARK: - Properties -
    var gigController = GigController()
    var dateFormatter = DateFormatter()
    
    
    //MARK: - Life Cycles -
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSignUpSegue", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "LoginSignUpSegue" {
           if let loginVC = segue.destination as? LogInViewController {
                loginVC.gigController = self.gigController
            }
        } else if segue.identifier == "ShowGig" {
            if let detailVC = segue.destination as? GigDetailViewController,
                let gigLocation = tableView.indexPathForSelectedRow?.row {
                detailVC.gigController = self.gigController
                detailVC.gig = self.gigController.gigs[gigLocation]
            }
        }
    }
    

}
