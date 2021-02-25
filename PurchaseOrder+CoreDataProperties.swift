//
//  PurchaseOrder+CoreDataProperties.swift
//  ButterflySystem
//
//  Created by Noman Saboor on 24/2/21.
//
//

import Foundation
import CoreData


extension PurchaseOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PurchaseOrder> {
        return NSFetchRequest<PurchaseOrder>(entityName: "PurchaseOrder")
    }

    @NSManaged public var active_flag: Bool
    @NSManaged public var approval_status: Int32
    @NSManaged public var delivery_note: String?
    @NSManaged public var device_key: String?
    @NSManaged public var id: Int32
    @NSManaged public var issue_date: Date?
    @NSManaged public var last_updated: Date?
    @NSManaged public var last_updated_user_entity_id: Int32
    @NSManaged public var preferred_deliver_date: Date?
    @NSManaged public var purchase_order_number: String?
    @NSManaged public var sent_date: Date?
    @NSManaged public var server_timestamp: Int32
    @NSManaged public var status: Int32
    @NSManaged public var supplier_id: Int32
    @NSManaged public var items: NSSet?
    @NSManaged public var invoices: NSSet?

}

// MARK: Generated accessors for items
extension PurchaseOrder {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for invoices
extension PurchaseOrder {

    @objc(addInvoicesObject:)
    @NSManaged public func addToInvoices(_ value: Invoice)

    @objc(removeInvoicesObject:)
    @NSManaged public func removeFromInvoices(_ value: Invoice)

    @objc(addInvoices:)
    @NSManaged public func addToInvoices(_ values: NSSet)

    @objc(removeInvoices:)
    @NSManaged public func removeFromInvoices(_ values: NSSet)

}

extension PurchaseOrder : Identifiable {

}
