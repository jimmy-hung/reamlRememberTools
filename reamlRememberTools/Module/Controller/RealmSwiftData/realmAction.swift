//
//  realmAction.swift
//  reamlRememberTools
//
//  Created by 洪立德 on 2019/1/25.
//  Copyright © 2019 洪立德. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAction : NSObject{
    
    let realm = try! Realm()

    
    // 寫入資料
    func writteInRealm(stock: Stock){
        try! realm.write {
            realm.add(stock)
        }
    }
    
    // 刪除資料
    func deleteRealm(stock: Stock){
        try! realm.write {
            realm.delete(stock)
        }
        
    }
    
    // 刪除資料所有
    func cleanUp(){
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
