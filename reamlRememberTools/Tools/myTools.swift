//
//  myTools.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/15.
//  Copyright © 2018 洪立德. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func getCorner(cornerItem: UIView, myCorner: CGFloat, cornerBG: UIColor){
        
        cornerItem.layer.cornerRadius = myCorner
        cornerItem.clipsToBounds = true
        cornerItem.backgroundColor = cornerBG
    }
    
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

