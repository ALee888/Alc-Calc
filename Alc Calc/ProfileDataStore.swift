//
//  ProfileDataStore.swift
//  Alc Calc
//
//  Created by Thorpen, Cole Patrick on 12/13/20.
//

import Foundation
import HealthKit

class ProfileDataStore {
    
    class func getSexAndAge() throws -> (age: Int?, biologicalSex: HKBiologicalSex) {
        let healthKitStore = HKHealthStore()
        
        do {
            //error if not available
            let dateOfBirthComponents = try healthKitStore.dateOfBirthComponents()
            let biologicalSex = try healthKitStore.biologicalSex()
            //calculate age
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year], from: today)
            let thisYear = todayDateComponents.year!
            let age = thisYear - dateOfBirthComponents.year!
            let gender = biologicalSex.biologicalSex
            
            return (age, gender)
        }
    }
    
}
