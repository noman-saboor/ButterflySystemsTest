//
//  PurchaseDetailViewController.swift
//  ButterflySystems-CoreDataTest
//
//  Created by Noman Saboor on 24/2/21.
//

import UIKit

class PurchaseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PurchaseOrderDelete {

    @IBOutlet weak var tableView: UITableView!
    
    var purchaseOrder:PurchaseOrder!
    var purchaseOrderDelegate:PurchaseOrderDelete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonTapped))

        tableView.register(UINib(nibName: "PurchaseDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "purchase_order_detail_cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK:- User Actions
    
    @objc func addItemButtonTapped() {
        let vc = storyboard?.instantiateViewController(identifier: "addNewItemVC") as! AddNewItemViewController
        vc.purchasedOrder = self.purchaseOrder
        vc.purchaseOrderDelegate = self
        present(vc, animated: true)
    }
    
    //MARK:- Purchase Order Delegate
    
    func orderItemAdded(_ purchaseOrder: PurchaseOrder) {
        self.purchaseOrder = purchaseOrder
        self.tableView.reloadData()
        if let delegate = purchaseOrderDelegate {
            delegate.orderItemAdded(purchaseOrder)
        }
    }
    
    //MARK:- Tableview Delegate & Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? purchaseOrder.items?.count ?? 0 : purchaseOrder.invoices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchase_order_detail_cell", for: indexPath) as! PurchaseDetailsTableViewCell
        
        if indexPath.section == 0 {
            if let itemsSet = self.purchaseOrder.items as? Set<Item> {
                let items = itemsSet.sorted(by: { $0.id < $1.id })
                let item = items[indexPath.row]
                
                cell.leftDescLabel.text = "Item ID: "
                cell.rightDescLabel.text = "Item Quantity: "
                cell.leftLabel.text = "\(item.id)"
                cell.rightLabel.text = "\(item.quantity)"
            }
        }
        else {
            if let invoicesSet = self.purchaseOrder.invoices as? Set<Invoice> {
                let invoices = invoicesSet.sorted(by: { $0.id < $1.id })
                let invoice = invoices[indexPath.row]
                
                cell.leftDescLabel.text = "Invoice ID: "
                cell.rightDescLabel.text = "Received Status: "
                cell.leftLabel.text = "\(invoice.id)"
                cell.rightLabel.text = "\(invoice.received_status == 0 ? "False" : "True")"
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Items" : "Invoices"
    }
}
