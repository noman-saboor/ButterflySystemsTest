//
//  AddPurchaseOrderViewController.swift
//  ButterflySystem
//
//  Created by Noman Saboor on 25/2/21.
//

import UIKit
import CoreData

class AddPurchaseOrderViewController: UIViewController {

    @IBOutlet weak var poIDTextField: UITextField!
    @IBOutlet weak var supplierIDTextField: UITextField!
    @IBOutlet weak var poNumberTextField: UITextField!
    @IBOutlet weak var deliveryNoteTextField: UITextField!
    
    var purchaseOrderDelegate:PurchaseOrderDelete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliveryNoteTextField.delegate = self
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PurchaseOrder", in: managedContext)!
        
        let order = NSManagedObject(entity: entity, insertInto: managedContext) as! PurchaseOrder
        
        order.id = Int32(poIDTextField.text!) ?? 0
        order.supplier_id = Int32(supplierIDTextField.text!) ?? 0
        order.purchase_order_number = poNumberTextField.text!
        order.delivery_note = deliveryNoteTextField.text!
        order.last_updated = Date()
        
        do {
            try managedContext.save()
            if let delegate = self.purchaseOrderDelegate {
                delegate.purchaseOrderAdded?()
            }
            dismiss(animated: true, completion: nil)

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        poIDTextField.resignFirstResponder()
        supplierIDTextField.resignFirstResponder()
        poNumberTextField.resignFirstResponder()
    }
}

extension AddPurchaseOrderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
