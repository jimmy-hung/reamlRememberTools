//
//  YearTableViewController.swift
//  reamlRememberTools
//
//  Created by 洪立德 on 2019/1/11.
//  Copyright © 2019 洪立德. All rights reserved.
//

import UIKit
import RealmSwift

class YearTableViewController: UIViewController {
    
    @IBOutlet weak var yearTableView: UITableView!
    var myDataArray : [Int] = []
    @IBOutlet weak var totalTradeLb: UILabel!
    @IBOutlet weak var sumLb: UILabel!
    
    var transitionView = false
    var realmAction = RealmAction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // 設置委任對象
        yearTableView.delegate = self
        yearTableView.dataSource = self
        
        yearTableView.getCorner(cornerItem: yearTableView, myCorner: 30, cornerBG: .clear)
        
        switch current {
        case .purple:
            view.backgroundColor = UIColor.init(displayP3Red: 204/255, green: 204/255, blue: 255/255, alpha: 1)
        case .pink:
            view.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        case .blue:
            view.backgroundColor = UIColor.init(displayP3Red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        case .systemDefault:
            view.addVerticalGradientLayer(topColor: .blue, bottomColor: .white)
        }
        
        // 分隔線的樣式
        yearTableView.separatorStyle = .none
        
        countSumTrade()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if transitionView == true {
            yearTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        transitionView = true
    }
    
    @IBAction func addAtn(_ sender: UIBarButtonItem) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "TableView") as! TableViewViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let realm = try! Realm()
        
        let myData = realm.objects(Stock.self)
        
        // 按年份排列資料
        let results = myData.sorted(byKeyPath: "year")
        
        let indexPath = yearTableView.indexPathForSelectedRow ?? []
        let index = results.filter("year = \(myDataArray[indexPath.row])")
        
        if segue.identifier == "goTable"{
            if myDataArray.count != 0 {
                if let nextVC = segue.destination as? TableViewViewController{
                    nextVC.infoDataYear = index.sorted(byKeyPath: "month")
                }
            }
        }
    }
    
    // 計算總交易次數 = 總共幾筆資料
    func countSumTrade(){
        let realm = try! Realm()
        let stock = realm.objects(Stock.self)
        totalTradeLb.text = String(stock.count)
        
        var sum : Double = 0
        
        if stock.count != 0 {
            for i in  0 ... (stock.count - 1) {
                let endPrice = Double(stock[i].count)! * ((Double(stock[i].sell_price)!) - (Double(stock[i].buy_price)!))
                sum = sum + endPrice
            }
            sum = sum * 1000
            
            if sum > 0{
                sumLb.textColor = .red
            }else if sum < 0{
                sumLb.textColor = .green
            }
        }
        sumLb.text = String(Int(sum.roundTo(places: 2)))
    }
    
}


extension YearTableViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let stock = realm.objects(Stock.self)
        
        // 重新獲取資料確保完整性
        myDataArray = []
        
        // 接出realm裡 年 的資料
        if stock.count != 0 {
            for i in 0 ... (stock.count - 1){
                myDataArray.append(stock[i].year)
            }

            myDataArray = myDataArray.removingDuplicates()
            // 將陣列從小排到大 ( reverse() 大 - 小 )
            myDataArray.sort()
        }
        
        countSumTrade() // 重置交易次數
        
        // 計算不同年份的數量，列出cell
        var yearSum = 1
        if myDataArray.count != 0 {
            for i in  0 ... (myDataArray.count - 1) {
                if myDataArray[0] != myDataArray[i] {
                    yearSum += 1
                }
            }
        }else{
            yearSum = 0
        }
        return yearSum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取得 tableView 目前使用的 cell
        let yearCell = tableView.dequeueReusableCell(withIdentifier: "YearCell", for: indexPath) as! YearTableViewCell
        
        // 設置 Accessory 按鈕樣式
        yearCell.accessoryType = .disclosureIndicator
    
        // 只顯示有購買記錄的年份
        if myDataArray.count != 0 {
            if indexPath.row == 0{
                yearCell.textLabel?.text = String(myDataArray[0])
                 yearCell.detailTextLabel?.text = ""
            }else{
                yearCell.textLabel?.text = String(myDataArray[indexPath.row])
                 yearCell.detailTextLabel?.text = ""
            }
        }
        return yearCell
    }
    
    // cell 右滑刪除
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 刪除 realm 資料 與 tableView 的 cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let realm = try! Realm()
        let stock = realm.objects(Stock.self).filter("year = \(myDataArray[indexPath.row]) ")
        
        for i in 1...stock.count{
            realmAction.deleteRealm(stock: stock[i - 1])
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
