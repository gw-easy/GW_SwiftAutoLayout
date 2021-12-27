//
//  ViewController.swift
//  GW_SwiftAutoLayout
//
//  Created by gw on 2020/9/8.
//  Copyright © 2020 gw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        test2()
//        test1()
    }

    func test2() {
        let lab1 = UILabel()
        let lab2 = UILabel()
        
        lab1.text = "史蒂夫届发就哦色圣诞节铁佛我"
        lab1.font = UIFont.systemFont(ofSize: 20)
        lab2.text = "势均力敌小客车距离速度快减肥减肥罗萨蒂就发水淀粉势均力敌小客车距离速度快减肥减肥罗萨蒂就发水淀粉势均力敌小客车距离速度快减肥减肥罗萨蒂就发水淀粉势均力敌小客车距离速度快减肥减肥罗萨蒂就发水淀粉势均力敌小客车距离速度快减肥减肥罗萨蒂就发水淀粉"
//        lab2.font = UIFont.systemFont(ofSize: 13)
        
        view.addSubview(lab1)
        view.addSubview(lab2)
        
        lab1.GWLeft(10)
            .GWTop(40, true)
            .GWRight(10)
            .GWHeightAuto()

        lab2.GWLeftEqual(lab1)
            .GWRightEqual(lab1)
            .GWTopBaseLine(8, toView: lab1, font: lab2.font)
            .GWHeightAuto()
        
//        lab1.GWLeft(10)
//            .GWTop(40, true)
//            .GWRight(10)
//            .GWLastBaseLine(20, toView: lab2, toViewFont: lab2.font)
//            .GWHeightAuto()
//
//        lab2.GWLeftEqual(lab1)
//            .GWRightEqual(lab1)
//            .GWHeightAuto()
    }

    func test1() {
        let view1:UIView = UIView.init()
        let view2:UIView = UIView.init()
        view1.backgroundColor = UIColor.red
        view2.backgroundColor = UIColor.green
        view.addSubview(view1)
        self.view.addSubview(view2)
        view1.GWTop(10, true)
        .GWLeft(0, true)
        .GWRight(0, true)
        .GWHeightAuto()
//        .GWBottom(0, true)
    
        
        view2.GWTop(10, toView: view1)
        .GWLeft(10, true)
        .GWRight(10, true)
        .GWHeightAuto()

        let aaa:UILabel = UILabel()
        aaa.text = """
        sdjfiejfejfowejfowijeofjskldfjilefesflet view1:UIView = UIView.init()
        """
        view2.addSubview(aaa)
        
        aaa.GWLeft(10)
            .GWTop(10)
            .GWRight(10)
            .GWBottom(10)
            .GWHeightAuto()
        
        aaa.GWTop(0).GWHeight(0)
        
        let textV:UITextView = UITextView()
//
        view1.addSubview(textV)
//        textV.text = "sdjfiejfsjefosejfisjfesef"
        textV.text = """
        sdjfiejfejfowejfowijeofjskldfjilefesflet view1:UIView = UIView.init()
        let view2:UIView = UIView.init()
        view1.backgroundColor = UIColor.red
        view2.backgroundColor = UIColor.green
        view.addSubview(view1)
        self.view.addSubview(view2)
        """
        textV.isScrollEnabled = false
        textV.textColor = .darkGray
        textV.backgroundColor = .yellow

        textV.GWLeft(0)
        .GWTop(20,true)
        .GWHeightAuto()
        .GWRight(0)
            .GWBottom(20)
        
//        textV.GWHeight(0)
        
        textV.GWHeightAuto()
        
        view1.GWHeight(0)
//        textV.superview?.layoutIfNeeded()
//
//        if textV.bounds.size.height > 80 {
//            textV.GWHeight(80)
//            textV.isScrollEnabled = true
//        }
    }
}

