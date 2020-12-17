//
//  Drink+CoreDataProperties.swift
//  Alc Calc
//
//  Created by Lee, Adam F on 12/15/20.
//
//

import Foundation
import CoreData


extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var alcohol: String?
    @NSManaged public var time: Date?
    static let dateFormatter: DateFormatter = {
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        return myDateFormatter
    }()

}

extension Drink : Identifiable {

}
