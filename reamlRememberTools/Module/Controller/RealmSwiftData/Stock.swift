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
    @objc dynamic var year : Int = 0
    @objc dynamic var month : Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var number : String = ""
    @objc dynamic var count : String = ""
    @objc dynamic var buy_date : String = ""
    @objc dynamic var sell_date : String = ""
    @objc dynamic var buy_price : String = ""
    @objc dynamic var sell_price : String = ""
    @objc dynamic var id = UUID().uuidString
    
    // 覆寫 primaryKey() 方法來告訴 Realm 說要使用自定義的 key 值
    override static func primaryKey() -> String? {
        return "id"
    }
//    @objc dynamic var arrayData: [String: [String:[String]]] = ["":["":[""]]]
}
