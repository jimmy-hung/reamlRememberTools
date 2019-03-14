//
//  LottieAnimationViewController.swift
//  GeneralShop
//
//  Created by kuansMacPro on 2018/10/29.
//  Copyright © 2018 郑州聚义. All rights reserved.
//

import UIKit
import Lottie

class LottieAnimationViewController: UIViewController {
  
    let url = URL(string: "https://jimmy-hung.github.io/myWebLottie/data.json") ?? URL(string: "https://www.apple.com/")!
    //(contentsOf: URL(string: "https://jimmy-hung.github.io/myWebLottie/data.json" ) ?? URL(string: "https://www.apple.com/")!)
    var animationView: LOTAnimationView!
    var animationViewUrl: LOTAnimationView!
    var animationViewFile: LOTAnimationView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    }
  
  public func startLottieAnimation(view: UIView) {
    animationViewUrl = LOTAnimationView(contentsOf: url)
    animationViewFile = LOTAnimationView(name: "special_circle")
    
    if  animationViewUrl != nil{
        animationView = animationViewUrl
    } else {
        animationView = animationViewFile
    }
    let imgFrame = view.frame
    let animationFrame = imgFrame
    
    animationView.backgroundColor = UIColor(displayP3Red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
    animationView.contentMode = .center
    animationView.loopAnimation = true
    animationView.frame = animationFrame
    view.addSubview(animationView)
    animationView.play()
    
    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
        self.closeLottieAnimation()
    }
  }
  
  public func closeLottieAnimation() {
    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
        self.animationView.loopAnimation = false
        self.animationView.isHidden = true
        self.animationView.stop()
        self.animationView.removeFromSuperview()
    }
  }
}
