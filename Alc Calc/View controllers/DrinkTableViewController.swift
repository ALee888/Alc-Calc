//
//  DrinkTableViewController.swift
//  Alc Calc
//
//  Created by Lee, Adam F on 12/15/20.
//

import UIKit
import CoreData

class DrinkTableViewController: UITableViewController {
    
    var drinkArray = [Drink]()
    var sortedDrink = [Drink]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load DrinkTableViewController")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadDrinks()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("appear")
        loadDrinks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfDays = 0
        let date = Date()
        let cal = Calendar.current
        var prevDay = cal.component(.day, from: date)
        if sortedDrink.count == 0
        {
            print("Sections: 0")
            return 0
        } else {
            for drink in sortedDrink {
                let calendar = Calendar.current
                let day = calendar.component(.day, from: drink.time!)
                if numOfDays == 0 {
                    prevDay = day
                    numOfDays += 1
                } else if day != prevDay {
                    prevDay = day
                    numOfDays += 1
                }
            }
        }
        print("Sections: \(numOfDays)")
        return numOfDays
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let drink = self.sortedDrink[section]
        let date = drink.time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date!)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Establish rows")
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return drinkArray.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Establish cells")
        let row = indexPath.row
        let drink = sortedDrink[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = ("\(String(drink.alcohol!))")
        
        //establish time
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: drink.time!)
        let minute = calendar.component(.minute, from: drink.time!)
        cell.detailTextLabel?.text = ("\(hour):\(minute)")
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    /**
    Read of CRUD
     */
    func sortDrink()
    {
        
        let tempArr = drinkArray
        
        sortedDrink = tempArr.sorted(by: {
            $0.time!.compare($1.time!) == .orderedDescending
        })
    }
    func loadDrinks()
    {
        print("Loading...")
        // we need to make a "request" to get the Category objects
        // via the persistent container
        let request: NSFetchRequest<Drink> = Drink.fetchRequest()
        // with a sql SELECT statement we usually specify a WHERE clause if we want to filter rows from the table we are selecting from
        // if we want to filter, we need to add a "predicate" to our request... we will do this later for Items
        do
        {
            drinkArray = try context.fetch(request)
        }
        catch
        {
            print("Error loading categories \(error)")
        }
        sortDrink()
        tableView.reloadData()
    }
}
