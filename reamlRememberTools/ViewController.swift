//
//  ViewController.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/15.
//  Copyright © 2018 洪立德. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nextPageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        nextPageBtn.getCorner(cornerItem: nextPageBtn, myCorner: 15, cornerBG: .lightGray)
        
    }
    
    // UserData = Stock
//    func insertUserData(name: String, number: String, count: String, bdate: String, sdate: String, bprice: String, sprice: String){
//        var user = NSEntityDescription.insertNewObject(forEntityName: "Stock", into: viewCotext) as! Stock
//
//        user.name = name
//        user.number = number
//        user.count = count
//        user.buy_date = bdate
//        user.sell_date = sdate
//        user.buy_price = bprice
//        user.sell_price = sprice
    
//        user.name = "晶電"
//        user.number = "2448"
//        user.count = "1"
//        user.buy_date = "2016.06.12"
//        user.sell_date = "2016.09.23"
//        user.buy_price = "24.384"
//        user.sell_price = "25.238"
        
//        user = NSEntityDescription.insertNewObject(forEntityName: "Stock", into: viewCotext) as! Stock
//        user.name = "中鋼"
//        user.number = "2002"
//        user.count = "1"
//        user.buy_date = "2016.08.23"
//        user.sell_date = "2016.11.11"
//        user.buy_price = "20.929"
//        user.sell_price = "24.443"
        
//        app.saveContext()
//
//    }
//    
//    func queryUserData(){
//        do {
//            let allUsers = try viewCotext.fetch(Stock.fetchRequest())
//            for user in allUsers as! [Stock]{
//                print("\(user.name), \(user.number), \(user.count), \(user.buy_date), \(user.sell_date), \(user.buy_price), \(user.sell_price)")
//            }
//        }catch {
//            print("Error : " + "\(error)")
//        }
//    }
    
}

