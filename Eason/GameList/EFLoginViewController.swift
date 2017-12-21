//
//  EFLoginViewController.swift - 登录界面
//  Eason
//
//  Created by Efun on 2017/10/23.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import SnapKit
import TextFieldEffects
import Alamofire

class EFLoginViewController: UIViewController {

    var usernameField: HoshiTextField?
    var passwordField: HoshiTextField?
    var loginButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupSubView()
        // Do any additional setup after loading the view.
    }

    func setupSubView() {
        
        let w: CGFloat = self.view.bounds.size.width / 1.5
        let h: CGFloat = 50
        let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        usernameField = HoshiTextField(frame: frame)
        usernameField?.borderActiveColor = UIColor(hexString: "4d8ff9")
        usernameField?.borderInactiveColor = UIColor.gray
        usernameField?.placeholder = "用户名"
        usernameField?.placeholderColor = UIColor.lightGray
        usernameField?.clearButtonMode = .whileEditing
        self.view.addSubview(usernameField!)
        
        usernameField?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.view).offset(-100)
            make.centerX.equalTo(self.view)
            make.width.equalTo(w)
            make.height.equalTo(h)
        })
        
        passwordField = HoshiTextField(frame: frame)
        passwordField?.borderActiveColor = UIColor.red
        passwordField?.borderInactiveColor = UIColor.gray
        passwordField?.placeholderColor = UIColor.lightGray
        passwordField?.placeholder = "密码"
        passwordField?.isSecureTextEntry = true
        self.view.addSubview(passwordField!)
        
        passwordField?.snp.makeConstraints({ (make) in
            make.top.equalTo((self.usernameField?.snp.bottom)!).offset(8)
            make.centerX.equalTo(self.view)
            make.width.equalTo(w)
            make.height.equalTo(h)
        })
        
        let colorImage =  UIImage(color: UIColor(hexString: "4d8ff9")!)
        loginButton = UIButton(type: .custom)
        loginButton?.setBackgroundImage(colorImage, for: .normal)
        loginButton?.setTitle("登录", for: .normal)
        loginButton?.setTitleColor(UIColor.white, for: .normal)
        loginButton?.addTarget(self, action: #selector(self.didClickLoginButton(button:)), for: .touchUpInside)
        self.view.addSubview(loginButton!)
        
        loginButton?.snp.makeConstraints({ (make) in
            make.top.equalTo((self.passwordField?.snp.bottom)!).offset(20)
            make.centerX.equalTo(self.view)
            make.width.equalTo(w)
            make.height.equalTo(30)
        })
        
        let userInfo = EFUserInfo.getUserInfo()
        if let username = userInfo[EFUserInfo.usernameKey] {
            usernameField?.text = username as? String
        }
    }
    
    @objc func didClickLoginButton(button: UIButton) {
        
        if usernameField?.text == nil || passwordField?.text == nil {
            let alertView = UIAlertController(title: "账号或密码不能为空", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        EFExamineTool.loadingView.startAnimating()
        EFNetworking.shared.fetchLoginInfo(username: usernameField!.text!, password: passwordField!.text!) { (response, error) in
            EFExamineTool.loadingView.stopAnimating()
            if error != nil {
                return
            }
            
            if response?["code"] as? String == "1000" {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                let message = response?["message"] as? String
                let alertView = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertView.addAction(cancelAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
