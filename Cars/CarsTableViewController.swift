//
//  CarsTableViewController.swift
//  Cars
//
//  Created by Claudio Cruz on 27/03/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {

    
    var dataSource: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCars()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "edit" {
            let vc = segue.destination as! ViewController
            vc.car = dataSource[tableView.indexPathForSelectedRow!.row]
        }
        
    }
    
    func loadCars(){
        REST.loadCars { (cars: [Car]?) in
            if let cars = cars{
                self.dataSource = cars
                DispatchQueue.main.async {
                    self.tableView.reloadData() //Atencao
                }
            }
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let car = dataSource[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = "\(car.price)"
        

        return cell
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let car = dataSource[indexPath.row]
            REST.deleteCar(car: car, onComplete: { (sucess: Bool) in
                DispatchQueue.main.async {
                    self.dataSource.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
            
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}
