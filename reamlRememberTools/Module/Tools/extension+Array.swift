//
//  extension+Array.swift
//  reamlRememberTools
//
//  Created by 洪立德 on 2019/1/26.
//  Copyright © 2019 洪立德. All rights reserved.
//
import UIKit

extension Array where Element: Hashable {
    // 移除相同項目
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
