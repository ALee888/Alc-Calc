//
//  Profile.swift
//  Alc Calc
//
//  Created by Thorpen, Cole Patrick on 12/13/20.
//

import Foundation
import HealthKit

class Profile {
    
    var age: Int?
    var biologicalSex: HKBiologicalSex?
    var weight: Double?
    var drinks: Double = 0
    var bloodAlcoholContent: Double? {
        guard let w = weight, let sex = biologicalSex, w > 0 else {
            return nil
        }
        let ounces = drinks
        let sexConstant: Double
        if sex.rawValue == 2{
            sexConstant = 3.75
        } else {
            sexConstant = 4.7
        }
        // MAXIMUM BAC without time
        return (((ounces)*(sexConstant))/w)
        
    }
    
    
}
