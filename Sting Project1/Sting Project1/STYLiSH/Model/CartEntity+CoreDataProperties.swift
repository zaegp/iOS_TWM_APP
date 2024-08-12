//
//  CartEntity+CoreDataProperties.swift
//  
//
//  Created by 謝霆 on 2024/8/12.
//
//

import Foundation
import CoreData


extension CartEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartEntity> {
        return NSFetchRequest<CartEntity>(entityName: "CartEntity")
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var title: NSObject?
    @NSManaged public var stock: NSObject?
    @NSManaged public var size: NSObject?
    @NSManaged public var price: NSObject?
    @NSManaged public var number: NSObject?
    @NSManaged public var color: NSObject?

}
