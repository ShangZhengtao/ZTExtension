//
//  ViewController.swift
//  ZTCategories
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 shang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testButton.setBackgroundColor(UIColor.red, .normal)
        testButton.touchExtendInset = UIEdgeInsets.init(top: -20, left: -20, bottom: -20, right: -20)
        
//        testButton.addAction(state: .touchUpInside) { (sender: UIButton) in
//        print("closure")
//        }  
        testButton.setImagePosition(.top,10)
        CALayer.getPropertyList()
    }

    
    @IBAction func touchButton(_ sender: UIButton) {
        print("touch")
        sender.startCountDown(5, "获取验证码", "s")
        
        //sss test 
//        testButton.showIndicator(title: "支付中..");
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { 
//            self.testButton.hiddenIndicator()
//        }
    }

}

