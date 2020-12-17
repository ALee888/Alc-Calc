//
//  ProfileViewController.swift
//  Alc Calc
//
//  Created by Thorpen, Cole Patrick on 12/13/20.
//

import UIKit
import HealthKit

class ProfileViewController: UITableViewController {

    @IBOutlet private var nameLabel:UILabel!
    @IBOutlet private var ageLabel:UILabel!
    @IBOutlet private var weightLabel:UILabel!
    @IBOutlet private var biologicalSexLabel:UILabel!
    @IBOutlet private var BAC: UILabel!
    private let profile = Profile()
    
    override func viewDidLoad() {
        
        updateHealthInfo()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        guard let bloodAlcoholContent = profile.bloodAlcoholContent else {
            print("missing bac")
            return
        }
        ProfileDataStore.saveBloodAlcoholContent(bloodAlcoholContent: bloodAlcoholContent, date: Date())
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
