//
//  ViewController.swift
//  Alc Calc
//
//  Created by Thorpen, Cole Patrick on 12/13/20.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authorizeHealthKit()
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


}

