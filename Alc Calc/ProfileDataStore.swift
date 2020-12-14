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
    class func getMostRecentSample(for sampleType: HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
                guard let samples = samples, let mostRecentSample = samples.first as? HKQuantitySample else {
                    completion(nil, error)
                    return
                }
                completion(mostRecentSample, nil)
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    class func saveBloodAlcoholContent(bloodAlcoholContent: Double, date: Date) {
        //checking for BAC existence
        guard let bloodAlcoholContentType = HKQuantityType.quantityType(forIdentifier: .bloodAlcoholContent) else {
            fatalError("Body Mass Index Type is no longer available in HealthKit")
        }
        // Use Count HKUnit to create a bloodAlcoholContent Quantity
        let bacQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: bloodAlcoholContent)
        let bacSample = HKQuantitySample(type: bloodAlcoholContentType, quantity: bacQuantity, start: date, end: date)
        
        // Save the same to HealthKit
        HKHealthStore().save(bacSample) { (success, error) in
            if let error = error {
                print("Error saving BAC sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved BMI Sample")
            }
        }
    }
}
