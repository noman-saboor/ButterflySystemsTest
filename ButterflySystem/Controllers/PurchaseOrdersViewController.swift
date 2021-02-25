//
//  ViewController.swift
//  ButterflySystems-CoreDataTest
//
//  Created by Noman Saboor on 24/2/21.
//

import UIKit
import CoreData
import Alamofire

@objc protocol PurchaseOrderDelete {
    @objc optional func purchaseOrderAdded()
    func orderItemAdded(_ purchaseOrder:PurchaseOrder)
}

class PurchaseOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PurchaseOrderDelete {

    @IBOutlet weak var tableView: UITableView!
    
    var purchaseOrders:[PurchaseOrder] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPOButtonTapped))
        
        tableView.register(UINib(nibName: "PurchaseOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "purchase_order_cell")
        retrieveData()
        getProductOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK:- User Actions
    
    @objc func addPOButtonTapped() {
        let vc = storyboard?.instantiateViewController(identifier: "addPurchaseOrderVC") as! AddPurchaseOrderViewController
        vc.purchaseOrderDelegate = self
        present(vc, animated: true)
    }
    
    //MARK:- Purchase Order Delegate
    
    func purchaseOrderAdded() {
        retrieveData()
    }
    
    func orderItemAdded(_ purchaseOrder: PurchaseOrder) {
        retrieveData()
    }
        
    func retrieveData() {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PurchaseOrder")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            self.purchaseOrders.removeAll()
            for data in result as! [NSManagedObject] {
                if let pOrder = data as? PurchaseOrder {
                    self.purchaseOrders.append(pOrder)
                }
            }
            self.tableView.reloadData()
            
        } catch {
            
            print("Failed")
        }
    }

    func getProductOrders(){
        AF.request("https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders").responseJSON { response in
            switch response.result {
                case .success(let json):
                    self.storeProductOrders(json)
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func storeProductOrders(_ json: Any){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PurchaseOrder", in: managedContext)!
        let entity1 = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
        let entity2 = NSEntityDescription.entity(forEntityName: "Invoice", in: managedContext)!

        if let jsonArray = json as? NSArray {
            for purchaseOrder in jsonArray {
                if let pOrder = purchaseOrder as? [String:Any] {
                    if let purchaseOrderID = pOrder["id"] as? Int32 {
                        if let puOrder = self.purchaseOrders.first(where: { $0.id == purchaseOrderID }) {
                            if let dateString = pOrder["last_updated"] as? String {
                                if let date = dateString.toDateTime() {
                                    if let lastUpdated = puOrder.last_updated {
                                        if lastUpdated == date {
                                            self.setObjectValue(puOrder, json: pOrder)
                                            
                                            if let items = puOrder.items {
                                                puOrder.removeFromItems(items)
                                            }
                                            
                                            if let invoices = puOrder.invoices {
                                                puOrder.removeFromInvoices(invoices)
                                            }
                                            
                                            if let items = pOrder["items"] as? NSArray {
                                                for item in items {
                                                    if let item = item as? [String:Any] {
                                                        let itemObject = NSManagedObject(entity: entity1, insertInto: managedContext) as! Item
                                                        self.setObjectValue(itemObject, json: item)
                                                        puOrder.addToItems(itemObject)
                                                    }
                                                }
                                            }
                                            
                                            if let invoices = pOrder["invoices"] as? NSArray {
                                                for invoice in invoices {
                                                    if let invoice = invoice as? [String:Any] {
                                                        let invoiceObject = NSManagedObject(entity: entity2, insertInto: managedContext) as! Invoice
                                                        self.setObjectValue(invoiceObject, json: invoice)
                                                        puOrder.addToInvoices(invoiceObject)
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            let order = NSManagedObject(entity: entity, insertInto: managedContext) as! PurchaseOrder
                            self.setObjectValue(order, json: pOrder)
                            
                            if let items = pOrder["items"] as? NSArray {
                                for item in items {
                                    if let item = item as? [String:Any] {
                                        let itemObject = NSManagedObject(entity: entity1, insertInto: managedContext) as! Item
                                        self.setObjectValue(itemObject, json: item)
                                        order.addToItems(itemObject)
                                    }
                                }
                            }
                            
                            if let invoices = pOrder["invoices"] as? NSArray {
                                for invoice in invoices {
                                    if let invoice = invoice as? [String:Any] {
                                        let invoiceObject = NSManagedObject(entity: entity2, insertInto: managedContext) as! Invoice
                                        self.setObjectValue(invoiceObject, json: invoice)
                                        order.addToInvoices(invoiceObject)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            do {
                try managedContext.save()
                self.retrieveData()

            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func setObjectValue(_ object:NSManagedObject, json:[String:Any]) {
        for key in json.keys {
            if object.responds(to: NSSelectorFromString(key)) {
                if let value = json[key] as? String {
                    if let date = value.toDateTime() {
                        object.setValue(date, forKey: key)
                    }
                    else {
                        object.setValue(value, forKey: key)
                    }
                }
                else if let value = json[key] as? Int32 {
                    object.setValue(value, forKey: key)
                }
            }
        }
    }

    //MARK:- Tableview Delegate & Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchase_order_cell", for: indexPath) as! PurchaseOrderTableViewCell
        cell.setupData(self.purchaseOrders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PurchaseDetailViewController") as! PurchaseDetailViewController
        vc.purchaseOrder = self.purchaseOrders[indexPath.row]
        vc.purchaseOrderDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
