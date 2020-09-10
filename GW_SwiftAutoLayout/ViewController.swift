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
        
        let view1:UIView = UIView.init()
        let view2:UIView = UIView.init()
        view1.backgroundColor = UIColor.red
        view2.backgroundColor = UIColor.green
        view.addSubview(view1)
        self.view.addSubview(view2)
        
        view1.GWTop(100)
        .GWLeft(10)
        .GWRight(10)
        .GWBottom(100)
    
//        view2.GWLeft(20)
//        .GWTop(200)
//        .GWRight(100)
//        .GWBottom(200)
//
//        view2.GWBottom(10)
//        .GWLeft(100)
        
        let textV:UITextView = UITextView()
        
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
        .GWTop(0)
        .GWRight(0)
        .GWHeightAuto()
    }


}
