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
        let weightGrams = w * 454
        let grams = drinks * 14
        let sexConstant: Double
        if sex.rawValue == 2{
            sexConstant = 0.55
        } else {
            sexConstant = 0.68
        }
        
        
        // MAXIMUM BAC without time
        return ((grams)/(weightGrams*sexConstant))*100
        
    }
    
    
}
