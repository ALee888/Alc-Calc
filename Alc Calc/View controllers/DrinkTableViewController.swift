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
    var sections = [Date]()
    
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
        let section = self.sections[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: section)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Establish rows")
        // #warning Incomplete implementation, return the number of rows
        var rows = 0
        let section = self.sections[section]
        let calendar = Calendar.current
        let day = calendar.component(.day, from: section)
        for drink in drinkArray {
            let drinkDay = calendar.component(.day, from: drink.time!)
            if day == drinkDay {
                rows += 1
            }
        }
        return rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        //print("Establish cells")
        var cellArray = [Drink]()
        let section = self.sections[indexPath.section]
        let calendar = Calendar.current
        let day = calendar.component(.day, from: section)
        for drink in drinkArray {
            let drinkDay = calendar.component(.day, from: drink.time!)
            if day == drinkDay {
                cellArray.append(drink)
            }
        }
        
        let drink = cellArray[indexPath.row]
        
        cell.textLabel?.text = ("\(String(drink.alcohol!))")
        
        //establish time
        var hour = calendar.component(.hour, from: drink.time!)
        let minute = calendar.component(.minute, from: drink.time!)
        if hour > 12 {
            hour -= 12
        }
        if minute < 10 {
            cell.detailTextLabel?.text = ("\(hour):0\(minute)")
        } else {
            cell.detailTextLabel?.text = ("\(hour):\(minute)")
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    @IBAction func editButtonPressed(_ sender: UIButton) {
        print("editing")
        let newEditingMode = !tableView.isEditing
        tableView.setEditing(newEditingMode, animated: true)
        
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            context.delete(sortedDrink[indexPath.row])
            print("SCARED")
            sortedDrink.remove(at: indexPath.row)
            print("REMOVED")
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("ROWS DELETED")
        }
    }
    /*
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
          {
              let drink = drinkArray.remove(at: sourceIndexPath.row)
              drinkArray.insert(drink, at: destinationIndexPath.row)
              tableView.reloadData()
          }
    */
    /**
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
         let drink = sortedDrink.remove(at: fromIndexPath.row)
         sortedDrink.insert(drink, at: fromIndexPath.row)
         tableView.reloadData()
         
     }
     */
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    func sortDrink()
    {
        let tempArr = drinkArray
        
        sortedDrink = tempArr.sorted(by: {
            $0.time!.compare($1.time!) == .orderedAscending
        })
        
        let today = Date()
        if (sortedDrink.count == 0)
        {
            sections.append(today)
        } else if (sortedDrink.count >= 1) {
            sections.append(sortedDrink[0].time!)
            if (sortedDrink.count > 1) {
                let Cal = Calendar.current
                    //let currDay = Cal.component(.day, from: today)
                    for drink in sortedDrink
                    {
                        let Day = Cal.component(.day, from: drink.time!)
                        for obj in sections
                        {
                            let comparisonDay = Cal.component(.day, from: obj)
                            if Day != comparisonDay
                            {
                                sections.append(drink.time!)
                            }
                        }
                    }
            }
        }
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
