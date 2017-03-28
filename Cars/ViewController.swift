//
//  ViewController.swift
//  Cars
//
//  Created by Claudio Cruz on 27/03/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfbrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    
    var car: Car!
    
    @IBAction func save(_ sender: Any) {
        
        if car == nil{
        let car = Car(brand: tfbrand.text!, name: tfName.text!, price: Double(tfPrice.text!)!, gasType: GasType(rawValue: scGasType.selectedSegmentIndex)!)
        
        REST.saveCar(car: car) { (success: Bool) in
            
            DispatchQueue.main.async {
                self.navigationController!.popViewController(animated: true)
            }
            
        }
        }else{
            car.name = tfName.text!
            car.brand = tfbrand.text!
            car.price = Double(tfPrice.text!)!
            car.gasType = GasType(rawValue: scGasType.selectedSegmentIndex)!
            REST.updateCar(car: car) { (success: Bool) in
                
                DispatchQueue.main.async {
                    self.navigationController!.popViewController(animated: true)
                }
                
            }
        }
            
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if car != nil {
            tfbrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType.rawValue
            title = "Atualizando \(car.name)"

    }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

