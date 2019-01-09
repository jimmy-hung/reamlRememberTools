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
    
}
