//
//  REST.swift
//  Cars
//
//  Created by Rafael Fioretti on 3/27/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import Foundation


class REST {
    
    static let basePath = "https://fiapcars.herokuapp.com/cars"
    static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        //URLSessionConfiguration.ephemeral //modo privado: apaga cookies, cache, etc
        //URLSessionConfiguration.background(withIdentifier: "bg")
        
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-type:": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 1
        
        return config
    }()
    static let session = URLSession(configuration: configuration)
    
    static func loadCars(onComplete: @escaping ([Car]?) -> Void){
        
        guard let url = URL(string: basePath) else{
            onComplete(nil)
            return
        }
        
        //GET
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil{
                onComplete(nil)
            } else {
                guard let response = response as? HTTPURLResponse else{
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200{
                    guard let data = data else{
                        onComplete(nil)
                        return
                    }
                    
                    let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [[String: Any]]
                    
                    var cars: [Car] = []
                    for item in json{
                        let brand = item["brand"] as! String
                        let name = item["name"] as! String
                        let price = item["price"] as! Double
                        let gasType = GasType(rawValue: item["gasType"] as! Int)!
                        let id = item["id"] as! String
                        let car = Car(brand: brand, name: name, price: price, gasType: gasType)
                        car.id = id
                        cars.append(car)
                    }
                    onComplete(cars)
                }else{
                    onComplete(nil)
                }
            }
        }.resume()
    }
    
        //POST
        static func saveCar(car: Car, onComplete: @escaping (Bool) -> Void){
            guard let url = URL(string: basePath) else{ return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let carDict: [String: Any] = ["brand": car.brand, "name": car.name, "price": car.price, "gasType": car.gasType.rawValue]
            
            let json = try! JSONSerialization.data(withJSONObject: carDict, options: JSONSerialization.WritingOptions())
            
            request.httpBody = json
            
            session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil{
                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        guard let data = data else { return }
                        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [String: Any]
                        let id = json["id"] as! String
                        car.id = id
                        onComplete(true)
                    }
                }
                
            }.resume()
        }
    
    //PATCH
    static func updateCar(car: Car, onComplete: @escaping (Bool) -> Void){
        guard let url = URL(string: "\(basePath)/\(car.id!)") else{ return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let carDict: [String: Any] = ["brand": car.brand, "name": car.name, "price": car.price, "gasType": car.gasType.rawValue]
        
        let json = try! JSONSerialization.data(withJSONObject: carDict, options: JSONSerialization.WritingOptions())
        
        request.httpBody = json
        
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil{
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    onComplete(true)
                }
            }
            
            }.resume()
    }
    
    //DELETE
    static func deleteCar(car: Car, onComplete: @escaping (Bool) -> Void){
        guard let url = URL(string: "\(basePath)/\(car.id!)") else{ return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let carDict: [String: Any] = ["brand": car.brand, "name": car.name, "price": car.price, "gasType": car.gasType.rawValue]
        
        let json = try! JSONSerialization.data(withJSONObject: carDict, options: JSONSerialization.WritingOptions())
        
        request.httpBody = json
        
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil{
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    onComplete(true)
                }
            }
            
            }.resume()
    }

    
}
