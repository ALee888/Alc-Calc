//
//  ProfileViewController.swift
//  Alc Calc
//
//  Created by Thorpen, Cole Patrick on 12/13/20.
//

import UIKit
import HealthKit
import CoreData

class ProfileViewController: UITableViewController {

    @IBOutlet private var nameLabel:UILabel!
    @IBOutlet private var ageLabel:UILabel!
    @IBOutlet private var weightLabel:UILabel!
    @IBOutlet private var biologicalSexLabel:UILabel!
    @IBOutlet private var BACLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var drinks = [Drink]()
    private let profile = Profile()
    
    private enum ProfileSection: Int{
        case userInfo
        case bloodAlcoholContent
        case saveBAC
    }
    
    override func viewDidLoad() {
        
        updateHealthInfo()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDrinks()
        drinksOverTime()
        profile.drinks = Double(drinks.count)
        updateLabels()
    }
    
    private func updateHealthInfo() {
        loadAndDisplaySexAndAge()
        loadAndDisplayMostRecentWeight()
    }
    private func loadAndDisplaySexAndAge() {
        do {
            let userAgeAndSex = try ProfileDataStore.getSexAndAge()
            profile.age = userAgeAndSex.age
            profile.biologicalSex = userAgeAndSex.biologicalSex
            updateLabels()
        }
        catch let error{
            print("error")
        }
    }
    
    private func loadAndDisplayMostRecentWeight() {
        //1. Use HealthKit to create the Height Sample Type
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
          print("Body Mass Sample Type is no longer available in HealthKit")
          return
        }
            
        ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
              
          guard let sample = sample else {
                
            if let error = error {
                print("ERROR")
            }
            return
          }
              
          let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.pound())
          self.profile.weight = weightInKilograms
          self.updateLabels()
        }
    }
    
    private func saveBloodAlcoholContentToHealthKit() {
        guard var bloodAlcoholContent = profile.bloodAlcoholContent else {
            print("missing bac")
            return
        }
        bloodAlcoholContent -= (drinksOverTime()*0.015)
        let formattedBAC = bloodAlcoholContent/100
        ProfileDataStore.saveBloodAlcoholContent(bloodAlcoholContent: formattedBAC, date: Date())
    }
    
    private func updateLabels(){
        if let age = profile.age {
            print(age)
          ageLabel.text = "\(age)"
        }

        if let biologicalSex = profile.biologicalSex {
            print(biologicalSex.rawValue)
            if (biologicalSex.rawValue == 2)
            {
                biologicalSexLabel.text = "Male"
            } else if (biologicalSex.rawValue == 1){
                biologicalSexLabel.text = "Female"
            } else {
                biologicalSexLabel.text = "Other"
            }
        }
        if let weight = profile.weight {
            print(weight)
            weightLabel.text = "\(weight)"
        }
        if var BAC = (profile.bloodAlcoholContent){
            BAC -= (drinksOverTime()*0.015)
            let displayBAC = BAC.truncate(places: 2)
            //print(displayBAC)
            BACLabel.text = "\(displayBAC)%"
        }
        
    }
    
    private func drinksOverTime() -> Double{
        var pastDrinks = [Drink]()
        let now = Date()
        let yesterday = Date().dayBefore
        print("Today:\(now) Yesterday: \(yesterday)")
        
        for drink in drinks {
            if drink.time! >= yesterday && drink.time! <= now
            {
                pastDrinks.append(drink)
            }
        }
        print("Past 24 hr: \(pastDrinks)")
        var latestDrink = Drink()
        if pastDrinks.count == 0 {
            return 0
        } else if pastDrinks.count >= 1 {
            latestDrink = pastDrinks[0]
            if pastDrinks.count > 1 {
                for drink in pastDrinks {
                    if drink.time! < latestDrink.time! {
                        latestDrink = drink
                    }
                }
            }
        }
        var timeDrinking = Date().timeIntervalSince(latestDrink.time!)
        timeDrinking = timeDrinking/3600
        print ("Time spent Drinking!!!\n\(timeDrinking) Min")
        return timeDrinking
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = ProfileSection(rawValue: indexPath.section) else {
            print("there was an error selecting the cell")
            return
        }
        
        switch section {
        case .saveBAC: saveBloodAlcoholContentToHealthKit()
        default: break
        }
        
        print("worked")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
            drinks = try context.fetch(request)
        }
        catch
        {
            print("Error loading categories \(error)")
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
