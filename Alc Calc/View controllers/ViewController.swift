//
//  ViewController.swift
//  Alc Calc
//
//  Created by Thorpen, Cole Patrick on 12/13/20.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var drinks = [Drink]()
    
    @IBOutlet weak var drinkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOAD VIEWCONTROLLER")
        // Do any additional setup after loading the view.
        authorizeHealthKit()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("Appear")
    }
    
    private func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
          guard authorized else {
            let baseMessage = "HealthKit Authorization Failed"
            if let error = error {
              print("\(baseMessage). Reason: \(error.localizedDescription)")
            } else {
              print(baseMessage)
            }
            return
          }
          print("HealthKit Successfully Authorized.")
        }
    }
    
    @IBAction func addBeer(_ sender: Any)
    {
        let currDrink = Drink(context: context)
        currDrink.alcohol = "🍺"
        currDrink.time = Date()
        
        drinks.append(currDrink)
    }
    @IBAction func addShot(_ sender: Any)
    {
        let currDrink = Drink(context: context)
        currDrink.alcohol = "🥃"
        currDrink.time = Date()
        
        drinks.append(currDrink)
    }
    @IBAction func addWine(_ sender: Any)
    {
        let currDrink = Drink(context: context)
        currDrink.alcohol = "🍷"
        currDrink.time = Date()
        
        drinks.append(currDrink)
    }
    @IBAction func addMixed(_ sender: Any)
    {
        let currDrink = Drink(context: context)
        currDrink.alcohol = "🍹"
        currDrink.time = Date()
        
        drinks.append(currDrink)
    }
    
    
    
    func saveDrink()
    {
        do
        {
            try(context.save())
        }
        catch
        {
            print("Error saving categories \(error)")
        }
    }
}

