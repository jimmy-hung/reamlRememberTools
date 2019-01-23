//
//  ViewController.swift
//  password
//
//  Created by 洪立德 on 2019/1/22.
//  Copyright © 2019 洪立德. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let key = "http://52.175.12.176/index/index/e72f053f-9b5d-49d5-9904-5ca717d0ff36+https://app-versions.herokuapp.com/index/index/cf4dd4f7-2995-427a-a771-dbfca84c89f5"
    
    let watch = "jvvr<1174039703403981kpfgz1kpfgz1g94h275h/;d7f/6;f7/;;26/7ec939f2hh58-jvvru<11crr/xgtukqpu0jgtqmwcrr0eqo1kpfgz1kpfgz1eh6ff6h9/4;;7/649c/c993/fdhec:6e:;h7"

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print("aciiMinus2Switch 加密後: \(aftersAciiMinus2Switch(str: key))")
        print("aciiMinus2Switch 加密前: \(beforeAsciiMinus2Switch(str: watch))")
    
    }
    
    // MARK: AciiMinus2Switch
    public func aftersAciiMinus2Switch(str: String) -> String {//轉為正確網址
        
        var str = String(str)
        var number = [UInt32]()
        var stringUrlSwitched = String()
        for code in str.unicodeScalars {
            number.append(code.value + 2)
            stringUrlSwitched.append(String(UnicodeScalar(number[number.count - 1])!))
        }
        return stringUrlSwitched
    }
    
    public func beforeAsciiMinus2Switch(str: String) -> String {//轉為正確網址
        
        var str = String(str)
        var number = [UInt32]()
        var stringUrlSwitched = String()
        for code in str.unicodeScalars {
            number.append(code.value - 2)
            stringUrlSwitched.append(String(UnicodeScalar(number[number.count - 1])!))
        }
        return stringUrlSwitched
    }
    
    
    // MARK: ASCII & UNICODE
    public enum ASC: Int {
        case a = 97 // 27
        case A = 65 // 27
        case number = 48 // 10
        case space = 32 // 33 包含數字0~9
    }
    
    public func toASCII(string: String) -> [Int] {
        var array = [Int]()
        for s in string.unicodeScalars {
            array.append(Int(s.value))
        }
        
        return array
    }
    
    // emoji 加密
    public func ascArrayToUnicodeExpression(array: [Int]) -> String {
        var output = ""
        
        for i in array {
            if i < ASC.a.rawValue {
                output += (UnicodeScalar(i + 128608)?.description)!
            }else{
                output += (UnicodeScalar(i + 128416)?.description)!
            }
        }
        return output
    }

    // emoji 解密
    public func characterToString(str: String) -> String {
        var output = ""
        for s in str.unicodeScalars {
            var value = 0
            value = Int(s.value) - 128416
            if value > 122 {
                value -= 192
            }
            output += UnicodeScalar(value)!.description
        }
        
        return output
    }
}

