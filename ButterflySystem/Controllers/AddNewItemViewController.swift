//
//  AddNewItemViewController.swift
//  ButterflySystem
//
//  Created by Noman Saboor on 25/2/21.
//

import UIKit
import CoreData

class AddNewItemViewController: UIViewController {

    @IBOutlet weak var itemIDTextField: UITextField!
    @IBOutlet weak var productIDTextField: UITextField!
    @IBOutlet weak var itemQuantityTextField: UITextField!
    
    var purchaseOrderDelegate:PurchaseOrderDelete?
    var purchasedOrder:PurchaseOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if let order = purchasedOrder {

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
            let item = NSManagedObject(entity: entity, insertInto: managedContext) as! Item

            item.id = Int32(itemIDTextField.text!) ?? 0
            item.product_item_id = Int32(productIDTextField.text!) ?? 0
            item.quantity = Int32(itemQuantityTextField.text!) ?? 0
            
            item.last_updated = Date()
            order.last_updated = Date()
            
            order.addToItems(item)
            
            do {
                try managedContext.save()
                if let delegate = self.purchaseOrderDelegate {
                    delegate.orderItemAdded(order)
                }
                dismiss(animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        itemIDTextField.resignFirstResponder()
        productIDTextField.resignFirstResponder()
        itemQuantityTextField.resignFirstResponder()
    }
}
