//
//  Item+CoreDataProperties.swift
//  ButterflySystem
//
//  Created by Noman Saboor on 24/2/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var active_flag: Bool
    @NSManaged public var id: Int32
    @NSManaged public var last_updated: Date?
    @NSManaged public var last_updated_user_entity_id: Int32
    @NSManaged public var product_item_id: Int32
    @NSManaged public var quantity: Int32
    @NSManaged public var transient_identifier: String?
    @NSManaged public var purchaseOrder: PurchaseOrder?

}

extension Item : Identifiable {

}
