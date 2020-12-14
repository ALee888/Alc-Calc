//
//  HealthKitSetupAssistant.swift
//  Alc Calc
//
//  Created by Thorpen, Cole Patrick on 12/13/20.
//

import Foundation
import HealthKit

class HealthKitSetupAssistant {
    
    private enum HealthKitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        //check if healthKit is available on device
        guard HKHealthStore.isHealthDataAvailable() else {
            print("healthKit is not available on this device")
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            return
        }
        //prepare data types that will interact with healthKit
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
              let bloodAlcoholContent = HKObjectType.quantityType(forIdentifier: .bloodAlcoholContent)
        else {
            print("needed data types (age, gender, or body mass) are not available. Please set up in Health App before using app.")
            completion(false, HealthKitSetupError.dataTypeNotAvailable)
            return
        }
        //prepare types to read and write from healthKit
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth, biologicalSex, bodyMass]
        let healthKitTypesToWrite: Set<HKSampleType> = [bloodAlcoholContent]
        //request authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) {(success, error) in
            completion(success, error)
        }
    }
    
}
