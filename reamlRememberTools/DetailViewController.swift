//
//  DetailViewController.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/16.
//  Copyright © 2018 洪立德. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var countLB: UILabel!
    @IBOutlet weak var end_priceLB: UILabel!
    @IBOutlet weak var buy_dateLB: UILabel!
    @IBOutlet weak var sell_dateLB: UILabel!
    @IBOutlet weak var buy_priceLB: UILabel!
    @IBOutlet weak var sell_priceLB: UILabel!
    @IBOutlet weak var resultLB: UILabel!
    
    var infoData:[Stock]! = []
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        
        let a = formatter.date(from: infoData[0].sell_date)!  // 賣出日期
        let b = formatter.date(from: infoData[0].buy_date)!  // 買入日期
        
        let days = b.daysBetweenDate(toDate: a)
        
        resultLB.adjustsFontSizeToFitWidth = true
        resultLB.text = "經過 \(String(describing: days)) 天，總共獲取 \((Int(spread() * 1000))) 金額"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        nameLB.text = infoData[0].name
        numberLB.text = infoData[0].number
        countLB.text = infoData[0].count
        end_priceLB.text = String(spread())
        buy_dateLB.text = infoData[0].buy_date
        sell_dateLB.text = infoData[0].sell_date
        buy_priceLB.text = infoData[0].buy_price
        sell_priceLB.text = infoData[0].sell_price
    }
    
    func spread() -> Double{
        
        let a = Double(infoData[0].sell_price)  // 賣出價格
        let b = Double(infoData[0].buy_price)   // 買入價格
        let c = Double(infoData[0].count)       // 張數
        
        let spread = (( a! - b! ) * c!).roundTo(places: 2)
        
        return spread
    }
}

