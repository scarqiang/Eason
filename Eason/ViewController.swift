//
//  ViewController.swift
//  Eason
//
//  Created by Efun on 2017/9/25.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Text"
        label.sizeToFit()
        self.view.addSubview(label)
        label.center = self.view.center;
        UIView.animate(withDuration: 1) {
           label.transform = CGAffineTransform.init(scaleX: 2, y: 2)
            label.textColor = UIColor.red
        }
        
        let textView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(textView)
        
        let textLayer = CATextLayer()
        textLayer.backgroundColor = UIColor.green.cgColor
        textLayer.frame = textView.layer.bounds
        textLayer.string = label.text
        textLayer.fontSize = 15
        textView.layer.addSublayer(textLayer)
        textLayer.foregroundColor = UIColor.black.cgColor
        
        textLayer.fontSize = 40
        let animation = CABasicAnimation(keyPath: "fontSize")
        animation.toValue = CGFloat(40)
        animation.fromValue = CGFloat(15)
        animation.duration = 2.0
        textLayer.add(animation, forKey: "label")
        
        textLayer.foregroundColor = UIColor.red.cgColor
        let colorAnimation = CABasicAnimation(keyPath: "foregroundColor")
        colorAnimation.fromValue = UIColor.black.cgColor;
        colorAnimation.toValue = UIColor.red.cgColor
        colorAnimation.duration = 4.0
        textLayer.add(colorAnimation, forKey: "label2")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickButton(_ sender: Any) {
        self.present(EFGameListViewController(), animated: true, completion: nil)
    }
    
    
}

