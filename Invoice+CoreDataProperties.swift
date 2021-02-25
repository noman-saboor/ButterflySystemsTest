//
//  Invoice+CoreDataProperties.swift
//  ButterflySystem
//
//  Created by Noman Saboor on 24/2/21.
//
//

import Foundation
import CoreData


extension Invoice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged public var active_flag: Bool
    @NSManaged public var created: Date?
    @NSManaged public var id: Int32
    @NSManaged public var invoice_number: String?
    @NSManaged public var last_updated: Date?
    @NSManaged public var last_updated_user_entity_id: Int32
    @NSManaged public var receipt_sent_date: Date?
    @NSManaged public var received_status: Int32
    @NSManaged public var transient_identifier: String?
    @NSManaged public var purchaseOrder: PurchaseOrder?

}

extension Invoice : Identifiable {

}
