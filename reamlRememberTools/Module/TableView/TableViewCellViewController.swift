//
//  TableViewCellViewController.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/15.
//  Copyright © 2018 洪立德. All rights reserved.
//

import UIKit

class TableViewCellViewController: UITableViewCell {

    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var countLB: UILabel!
    @IBOutlet weak var end_priceLB: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
