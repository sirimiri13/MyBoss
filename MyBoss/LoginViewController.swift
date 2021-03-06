//
//  LoginViewController.swift
//  MyBoss
//
//  Created by Huong Lam on 6/1/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController, UINavigationControllerDelegate{
    
    let templateColor = UIColor.white
    var emailTextFied = UITextField()
    let bgImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "userbg.jpg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let errorLabel : UILabel = {
        let errLabel = UILabel()
        // errLabel.alpha = 0
        return errLabel
    }()
    
    let bgView : UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor(displayP3Red: 9.0/255.0, green: 33.0/255.0, blue: 47.0/255.0, alpha: 1.0).withAlphaComponent(0.7)
        return bgView
    }()
    
    let textFieldView1 : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    
    let textFieldView2 : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    
    let signInButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgotPassword : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addingUIElements()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showError(message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
        errorLabel.backgroundColor = .red
    }
    
    func addingUIElements() {
        let padding: CGFloat = 40.0
        let signInButtonHeight: CGFloat = 50.0
        let textFieldViewHeight: CGFloat = 60.0
        
        // Background imageview
        self.view.addSubview(bgImageView)
        bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        
        // Background layer view
        view.insertSubview(bgView, aboveSubview: bgImageView)
        bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        
        
        // Email textfield and icon
        view.insertSubview(textFieldView1, aboveSubview: bgView)
        textFieldView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 300.0).isActive = true
        textFieldView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        textFieldView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        textFieldView1.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        
        textFieldView1.imgView.image = UIImage(named: "profile")
        let attributesDictionary = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        textFieldView1.textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        textFieldView1.textField.textColor = templateColor
        
        // Password textfield and icon
        view.insertSubview(textFieldView2, aboveSubview: bgView)
        textFieldView2.topAnchor.constraint(equalTo: textFieldView1.bottomAnchor, constant: 0.0).isActive = true
        textFieldView2.leadingAnchor.constraint(equalTo: textFieldView1.leadingAnchor, constant: 0.0).isActive = true
        textFieldView2.trailingAnchor.constraint(equalTo: textFieldView1.trailingAnchor, constant: 0.0).isActive = true
        textFieldView2.heightAnchor.constraint(equalTo: textFieldView1.heightAnchor, constant: 0.0).isActive = true
        
        textFieldView2.imgView.image = UIImage(named: "lock")
        textFieldView2.textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
        textFieldView2.textField.isSecureTextEntry = true
        textFieldView2.textField.textColor = templateColor
        
      
        
        // Sign In Button
        view.insertSubview(signInButton, aboveSubview: bgView)
        signInButton.topAnchor.constraint(equalTo: textFieldView2.bottomAnchor, constant: 20.0).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: textFieldView2.leadingAnchor, constant: 0.0).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: textFieldView2.trailingAnchor, constant: 0.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        let buttonAttributesDictionary = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0),
                                          NSAttributedString.Key.foregroundColor: templateColor]
        signInButton.alpha = 0.4
        signInButton.backgroundColor = UIColor.black
        signInButton.setAttributedTitle(NSAttributedString(string: "SIGN IN", attributes: buttonAttributesDictionary), for: .normal)
        signInButton.isEnabled = true
        signInButton.addTarget(self, action: #selector(signInButtonTapped(button:)), for: .touchUpInside)
        
        // Forgot Password Button
        view.insertSubview(forgotPassword, aboveSubview: bgView)
        forgotPassword.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 0.0).isActive = true
        forgotPassword.leadingAnchor.constraint(equalTo: textFieldView1.leadingAnchor, constant: 0.0).isActive = true
        forgotPassword.trailingAnchor.constraint(equalTo: textFieldView1.trailingAnchor, constant: 0.0).isActive = true
        
        forgotPassword.setTitle("Forgot password?", for: .normal)
        forgotPassword.setTitleColor(templateColor, for: .normal)
        forgotPassword.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        forgotPassword.addTarget(self, action: #selector(forgotPasswordButtonTapped(button:)), for: .touchUpInside)
    }
    
    @objc private func signInButtonTapped(button: UIButton) {
        let hud = JGProgressHUD(style: .dark)
        let username = textFieldView1.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = textFieldView2.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        hud.show(in: self.view)
        DispatchQueue.global(qos: .background).async {
            Auth.auth().signIn(withEmail: username!, password: pass!) { (res, err) in
                hud.dismiss(animated: true)
                if (err != nil){
                    self.showAlertVC(title: err!.localizedDescription)
                }
                else {
                    
                    DispatchQueue.main.async {
                        if let tabbar = (self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController) {
                            let navController = UINavigationController(rootViewController: tabbar)
                            navController.modalPresentationStyle = .fullScreen
                            self.present(navController, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
    @objc private func forgotPasswordButtonTapped(button: UIButton) {
        let alert = UIAlertController(title: "Forgot Password",message: "Please enter your email",preferredStyle: .alert)
       
        let cancelAction = UIAlertAction(title: "Cancel",style: .cancel, handler: nil)
        let doneAction =  UIAlertAction(title: "Reset Password",style: .default) { (alert) in
            Auth.auth().sendPasswordReset(withEmail: self.emailTextFied.text!) { (err) in
                let resetAlert = UIAlertController(title: "Reset Password",message: "Please check your email",preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                resetAlert.addAction(okAction)
                self.present(resetAlert,animated: true)
            }
            
        }
        alert.addTextField{ (emailTextFied) in
            self.getemailTextFied(textField: emailTextFied)
            
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        present(alert,animated: true)
        //  showAlertVC(title: "Forgot password tapped")
    }
    
    func getemailTextFied(textField: UITextField){
        emailTextFied = textField
        emailTextFied.placeholder = "Enter your emaill"
    }
    
    func showAlertVC(title: String) {
        let alertController = UIAlertController(title: "MESSAGE", message: title, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
}

class TextFieldView: UIView {
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let textField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let lineView : UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addingSubviews()
    }
    
    func addingSubviews() {
        self.addSubview(lineView)
        lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        self.addSubview(imgView)
        imgView.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -15.0).isActive = true
        imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor, constant: 0.0).isActive = true
        
        self.addSubview(textField)
        textField.lastBaselineAnchor.constraint(equalTo: imgView.lastBaselineAnchor, constant: -1.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8.0).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

