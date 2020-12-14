//
//  ProfileViewController.swift
//  Alc Calc
//
//  Created by Thorpen, Cole Patrick on 12/13/20.
//

import UIKit
import HealthKit

class ProfileViewController: UIViewController {

    @IBOutlet private var nameLabel:UILabel!
    @IBOutlet private var ageLabel:UILabel!
    @IBOutlet private var biologicalSexLabel:UILabel!
    
    private let profile = Profile()
    
    override func viewDidLoad() {
        updateHealthInfo()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func updateHealthInfo() {
        loadAndDisplaySexAndAge()
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
