//
//  PurchaseOrderTableViewCell.swift
//  ButterflySystems-CoreDataTest
//
//  Created by Noman Saboor on 24/2/21.
//

import UIKit

class PurchaseOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    var purchaseOrder:PurchaseOrder?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.idLabel.text = "N/A"
        self.numberOfItemsLabel.text = "N/A"
        self.lastUpdatedLabel.text = "N/A"
    }
    
    func setupData(_ purchaseOrder: PurchaseOrder) {
        self.purchaseOrder = purchaseOrder
        
        self.idLabel.text = "\(purchaseOrder.id)"
        self.numberOfItemsLabel.text = "\(purchaseOrder.items?.count ?? 0)"
        
        if let lastUpdated = self.purchaseOrder?.last_updated {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            let lastUpdatedDateTime = dateFormatter.string(from: lastUpdated)
            self.lastUpdatedLabel.text = "\(lastUpdatedDateTime)"
        }
    }
}
