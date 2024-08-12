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

    @NSManaged public var image: String?
    @NSManaged public var size: String?
    @NSManaged public var title: String?
    @NSManaged public var stock: String?
    @NSManaged public var color: String?
    @NSManaged public var price: String?
    @NSManaged public var number: String?

}
