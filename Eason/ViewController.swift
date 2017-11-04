//
//  ViewController.swift
//  Eason
//
//  Created by Efun on 2017/9/25.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        let testview = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        testview.backgroundColor = UIColor.red
        view.addSubview(testview)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Text"
        label.sizeToFit()
//        self.view.addSubview(label)
        label.center = self.view.center;
        UIView.animate(withDuration: 1) {
           label.transform = CGAffineTransform.init(scaleX: 2, y: 2)
            label.textColor = UIColor.red
        }
        
        let textView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        view.addSubview(textView)
        
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
        let gameListVC = EFGameListViewController()
        let navbar = UINavigationController(rootViewController: gameListVC)
        self.present(navbar, animated: true, completion: nil)
    }
    
    @IBAction func presentToTestVC(_ sender: Any) {
        //test collectionNode
//        let testVC = EFTestViewController(node: ASDisplayNode())
//        let navbar2 = UINavigationController(rootViewController: testVC)
//        self.present(navbar2, animated: true, completion: nil)
        
        //test database
//        let jsonString = jsonToString(json: ["result": ["testString":"XXX"], "resultLists": [["testString":"XXX1"], ["testString":"XXX2"]]])
//        let wap = EFAnalyzeWapModel(JSONString: jsonString)
//        let wap = EFAnalyzeWapModel(value: ["result":["testString":"XXX"]])
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(wap!)
//        }
//        let wapList = realm.objects(EFAnalyzeWapModel.self)
//        print("\(wapList)")
        
        //test open url
//        let url = URL(string: "twtestios://networking_mode")
//        UIApplication.shared.openURL(url!)
        EFExamineTool.taggerTestMode(uuidReset: false, userDefaultReset: false, gameCode: "krtestios")

        //tes hexstring to data
//        let hexString = "7b2266696c655f6e616d65223a2231353036333933313332222c22757365725f64656661756c745f7265736574223a302c22757569645f7265736574223a307d"
//        let data:Data = (String.hexadecimal(hexString)())!
//        let string = String(data: data, encoding: String.Encoding.utf8) as String!
//        let hexStr = data.hexadecimal()
        
        //test networking
//        let netManager = EFNetworking.shared
//        netManager.fetchGameList(area: .sea) { (gameList) in
//            print(gameList!)
//        }
        
    }
    
    @IBAction func testNetMode(_ sender: Any) {
        
        EFExamineTool.taggerNetworkMode(gameCode: "krtestios")
    }
    
}

