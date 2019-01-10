//
//  Stock.swift
//  reamlRememberTools
//
//  Created by 洪立德 on 2019/1/3.
//  Copyright © 2019 洪立德. All rights reserved.
//

import Foundation
import RealmSwift

class Stock: Object {
    @objc dynamic var year : String = ""
    @objc dynamic var month : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var number : String = ""
    @objc dynamic var count : String = ""
    @objc dynamic var buy_date : String = ""
    @objc dynamic var sell_date : String = ""
    @objc dynamic var buy_price : String = ""
    @objc dynamic var sell_price : String = ""
    
//    @objc dynamic var arrayData: [String: [String:[String]]] = ["":["":[""]]]
}
