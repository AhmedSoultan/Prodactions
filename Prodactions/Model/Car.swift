//
//  Car.swift
//  Prodactions
//
//  Created by Ahmed Sultan on 10/18/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit
class Car {
    var id: String!
    var title: String!
    var price: Int!
    var city: String!
    var date: String!
    var category: String!
    
    class func carFrom(id:String, data:[String:Any]) -> Car? {
        if let title = data["title"] as? String,
                let price = data["price"] as? Int,
                let city = data["city"] as? String,
                let date = data["date"] as? String
                //let image = data["image"] as? String
        {
            let car = Car()
            car.title = title
            car.price = price
            car.city = city
            car.date = date
            //car.image = image
            car.id = id
            return car
        }
        return nil
    }
    
    
}
