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
    
    // 更新資料
    func upDate (data: Stock){
        try! realm.write {
            // 必須有定義key值才能傳入true
            realm.add(data, update: true)
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
        UserDefaults().set("", forKey: "duringDate") // 清空累計天數
    }
    
}
