//
//  ViewController.swift
//  CoreDataApp
//
//  Created by student on 3/9/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var breadStringArray = [String]()
    var cheeseStringArray = [String]()
    var meatStringArray = [String]()
    var condimentStringArray = [String]()
    var toppingsStringArray = [String]()
    var ordersStringArray = [String]()
    
    var breadArray = [NSManagedObject]()
    var cheeseArray = [NSManagedObject]()
    var meatArray = [NSManagedObject]()
    var condimentArray = [NSManagedObject]()
    var toppingsArray = [NSManagedObject]()
    var ordersArray = [NSManagedObject]()
    
    var breadString = "White Bread, Whole Wheat Bread, Multigrain Bread, Sourdough Bread, Rye Bread, Ciabatta, Baguette, Pumpernickel Bread, Garlic Bread, Cinnamon Raisin Bread"
    var cheeseString = "Cheddar, Swiss, Gouda, Brie, Blue Cheese, Feta, Provolone, Mozzarella, Gruyère, Parmesan, Camembert, Havarti"
    var meatString = "Ham, Turkey, Chicken, Roast Beef, Salami, Pastrami, Bacon, Pepperoni, Prosciutto, Capicola, Sausage, Corned Beef"
    var condimentString = "Mayonnaise, Mustard, Ketchup, Soy Sauce, Hot Sauce, Barbecue Sauce, Honey Mustard, Pesto, Dijon Mustard, Ranch Dressing, Tahini, Sriracha"
    var toppingsString = "Lettuce, Tomato, Onion, Pickles, Cucumber, Bell Pepper, Spinach, Olives, Avocado, Jalapeños, Sprouts"
    var ordersString = ""
    
    var nameEntered = ""
    var breadSelected = "White Bread"
    var cheeseSelected = "Cheddar"
    var meatSelected = "Ham"
    var condimentSelected = "Mayonnaise"
    var toppingsSelected = "Lettuce"
    var cutOption = false
    
    var dataManager: NSManagedObjectContext!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var breadPicker: UIPickerView!
    @IBOutlet weak var cheesePicker: UIPickerView!
    @IBOutlet weak var meatPicker: UIPickerView!
    @IBOutlet weak var condimentPicker: UIPickerView!
    @IBOutlet weak var toppingsPicker: UIPickerView!
    
    @IBOutlet weak var slider: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Sandwich", into: dataManager)
        newEntity.setValue(breadString, forKey: "bread")
        newEntity.setValue(cheeseString, forKey: "cheese")
        newEntity.setValue(meatString, forKey: "meat")
        newEntity.setValue(condimentString, forKey: "condiment")
        newEntity.setValue(toppingsString, forKey: "toppings")
        
        do {
            try self.dataManager.save()
            breadArray.append(newEntity)
            cheeseArray.append(newEntity)
            meatArray.append(newEntity)
            condimentArray.append(newEntity)
            toppingsArray.append(newEntity)
        }
        catch {
            print("Error saving the data")
        }
        fetchData()
    }
    
    func fetchData() {
        let fetchResult: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Sandwich")
        
        do {
            let result = try dataManager.fetch(fetchResult)
            ordersArray = result as! [NSManagedObject]
            
            for item in ordersArray {
                if let bread = item.value(forKey: "bread") as? String {
                    breadStringArray = bread.components(separatedBy: ",")
                }
                else {
                }
                if let cheese = item.value(forKey: "cheese") as? String {
                    cheeseStringArray = cheese.components(separatedBy: ",")
                }
                else {
                }
                if let meat = item.value(forKey: "meat") as? String {
                    meatStringArray = meat.components(separatedBy: ",")
                }
                else {
                }
                if let condiment = item.value(forKey: "condiment") as? String {
                    condimentStringArray = condiment.components(separatedBy: ",")
                }
                else {
                }
                if let toppings = item.value(forKey: "toppings") as? String {
                    toppingsStringArray = toppings.components(separatedBy: ",")
                }
                else {
                }
            }
        }
        catch {
            print("Error retrieving the data")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == breadPicker {
            return breadStringArray.count
        }
        else if pickerView == cheesePicker {
            return cheeseStringArray.count
        }
        else if pickerView == meatPicker {
            return meatStringArray.count
        }
        else if pickerView == condimentPicker {
            return condimentStringArray.count
        }
        else if pickerView == toppingsPicker {
            return toppingsStringArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == breadPicker {
            return breadStringArray[row]
        }
        else if pickerView == cheesePicker {
            return cheeseStringArray[row]
        }
        else if pickerView == meatPicker {
            return meatStringArray[row]
        }
        else if pickerView == condimentPicker {
            return condimentStringArray[row]
        }
        else if pickerView == toppingsPicker {
            return toppingsStringArray[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == breadPicker {
            breadSelected = breadStringArray[row]
        }
        else if pickerView == cheesePicker {
            cheeseSelected = cheeseStringArray[row]
        }
        else if pickerView == meatPicker {
            meatSelected = meatStringArray[row]
        }
        else if pickerView == condimentPicker {
            condimentSelected = condimentStringArray[row]
        }
        else if pickerView == toppingsPicker {
            toppingsSelected = toppingsStringArray[row]
        }
    }
    
    @IBAction func clearBtn(_ sender: UIButton) {
        resetView()
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        nameEntered = nameTF.text!
        cutOption = slider.isOn
        
        let order = "\(nameEntered) - \(breadSelected), \(cheeseSelected), \(meatSelected), \(condimentSelected), \(toppingsSelected), \(cutOption)"
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Sandwich", into: dataManager)
        newEntity.setValue(order, forKey: "orders")
        
        do {
            try self.dataManager.save()
            ordersArray.append(newEntity)
            
            let alert = UIAlertController(title: "Success", message: "The item has been added successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: {
                action -> Void in
            })
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            resetView()
        }
        catch {
            print("Error saving the data")
        }
        
        nameEntered = ""
        breadSelected = "White Bread"
        cheeseSelected = "Cheddar"
        meatSelected = "Ham"
        condimentSelected = "Mayonnaise"
        toppingsSelected = "Lettuce"
        cutOption = false
    }
    
    func resetView() {
        nameTF.text = ""
        
        breadPicker.selectRow(0, inComponent: 0, animated: true)
        cheesePicker.selectRow(0, inComponent: 0, animated: true)
        meatPicker.selectRow(0, inComponent: 0, animated: true)
        condimentPicker.selectRow(0, inComponent: 0, animated: true)
        toppingsPicker.selectRow(0, inComponent: 0, animated: true)
        
        slider.isOn = false
    }
}
