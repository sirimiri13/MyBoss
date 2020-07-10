//
//  InformationViewController.swift
//  MyBoss
//
//  Created by Huong Lam on 6/4/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseAuth
import JGProgressHUD


class InformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let email = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    var textEdit: String = ""
    var newPw = UITextField()
    var confirmPw = UITextField()
   
    @IBOutlet weak var editSalaryButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var basicSalaryLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var imageURL : String = ""
    var editTextField = UITextField()
    var edit : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
           imagePicker.delegate = self
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        DispatchQueue.global(qos: .background).async {
            self.setUpData()
          //  self.loadView()
            self.db.collection("user").getDocuments { (snap, err) in
                for acc in snap!.documents {
                    if (acc.documentID == self.email){
                        hud.dismiss(animated: true)
                        DispatchQueue.main.async {
                              self.editSalaryButton.alpha = 0
                        }
                      
                    }
                   
                }
            }
        }
     
        
}
        
    
   
    func setUpData(){
        db.collection("user").document(email!).getDocument { (Snapshot, err) in
                if (err == nil){
                    self.imageURL = Snapshot?.data()!["avatar"] as! String 
                    let ref = Storage.storage().reference(forURL: self.imageURL)
                            ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                                if error == nil {
                                    self.profileImageView.image = UIImage(data: data!)
                                }
                            }
                    self.firstNameLabel.text = Snapshot?.data()!["FirstName"] as! String
                    self.lastNameLabel.text = Snapshot?.data()!["LastName"] as! String
                    self.emailLabel.text = Snapshot?.data()!["Email"] as! String
                    self.phoneLabel.text = Snapshot?.data()!["Phone"] as! String
                    self.basicSalaryLabel.text = Snapshot?.data()!["BasicSalary"] as! String
                    }
                }
        
    }

        // Do any additional setup after loading the view.
    
    @IBAction func editProfileImageTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Please confirm", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (UIAlertAction) in
           try! Auth.auth().signOut()
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))! as! LoginViewController
            vc.modalPresentationStyle =  .fullScreen
            self.present(vc, animated: false)
        }
        alert.addAction(cancelAction)
        alert.addAction(signOutAction)
        present(alert,animated: true)
        
    }
    @IBAction func changePwTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Change Password", message: "Please enter your edit", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: self.changePw(alert:))
        alert.addTextField { (newPw) in
            self.newPw(textFiled: newPw)
        }
        alert.addTextField { (confirmPw) in
            self.confirmPw(textFiled: confirmPw)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert,animated: true)
    }
    func newPw(textFiled: UITextField) {
        self.newPw = textFiled
        self.newPw.placeholder = "Please enter new password"
    }
    func confirmPw(textFiled: UITextField) {
           self.confirmPw = textFiled
        self.confirmPw.placeholder = "Please confirm new password"
       }
    
    func changePw(alert: UIAlertAction){
        if (Utilities.isPasswordValid(newPw.text!) == false){
            let alertError = UIAlertController(title: "Error", message:  "Please check your password is least 8 characters, contains a special character and a number", preferredStyle: .alert)
            let tryAction = UIAlertAction(title: "Try again", style: .destructive, handler: nil)
            alertError.addAction(tryAction)
            self.present(alertError,animated: false)
        }
        else {
            if (self.newPw.text == self.confirmPw.text){
                Auth.auth().currentUser?.updatePassword(to: newPw.text!, completion: { (err) in
                    if (err == nil){
                        let alertSuccessful = UIAlertController(title:"Successful", message:  "Your password have been updated", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertSuccessful.addAction(okAction)
                        self.present(alertSuccessful,animated: false)
                    }
                    else {
                        let alertError = UIAlertController(title: "Error", message:  err?.localizedDescription, preferredStyle: .alert)
                        let tryAction = UIAlertAction(title: "Try again", style: .destructive, handler: nil)
                        alertError.addAction(tryAction)
                        self.present(alertError,animated: false)
                    }
                })
            }
            else {
                let alertError = UIAlertController(title: "Error", message:  "Confirm password is wrong", preferredStyle: .alert)
                let tryAction = UIAlertAction(title: "Try again", style: .destructive, handler: nil)
                alertError.addAction(tryAction)
                self.present(alertError,animated: false)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let storageRef = Storage.storage().reference().child("profile/\(email!)")
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        let pickerData = pickedImage.jpegData(compressionQuality: 1)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.putData(pickerData!,metadata: metaData){(metaData,err) in
        guard metaData != nil else { return}
            storageRef.downloadURL{(url,err) in
                guard url != nil else {return}
            }
        }
        let db = Firestore.firestore()
        db.collection("user").document(email!).updateData(["avatar": "gs://myboss-27d17.appspot.com/profile/\(email!)"])
        //setUpData()
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageView.image = imagePicked
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.profileImageView.reloadInputViews()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func editFirstNameTapped(_ sender: Any) {
        self.edit = "FirstName"
        showAlert(textLabel: "FirstName")
  //      self.fristNameLabel.text = textEdit
        self.setUpData()
        
    }
    
    
    @IBAction func editLastNameTapped(_ sender: Any) {
        self.edit = "LastName"
        showAlert(textLabel: "LastName")
   //     self.lastNameLabel.text = textEdit
    }
    
    @IBAction func editPhoneTapped(_ sender: Any) {
        self.edit = "Phone"
        showAlert(textLabel: "Phone")
        self.setUpData()
        
    }
    
    @IBAction func editSalaryTapped(_ sender: Any) {
        self.edit = "BasicSalary"
        showAlert(textLabel: "BasicSalary")
       self.setUpData()
    }
    func showAlert(textLabel: String){
        let alert = UIAlertController(title: textLabel, message: "Please enter your edit", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: self.getEditTextField(alert:))
        alert.addTextField { (editTextField) in
            self.editTextField(textField: editTextField)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert,animated: true)
        }
    
    func editTextField(textField: UITextField!){
        editTextField = textField
        editTextField.placeholder = "Enter your edit...."
    }
    func getEditTextField(alert : UIAlertAction){
        self.textEdit = editTextField.text!
        if (self.edit == "LastName"){
            self.lastNameLabel.text = editTextField.text
        }
        if (self.edit == "FirstName"){
            self.firstNameLabel.text = editTextField.text
        }
        if (self.edit == "Phone"){
                   self.phoneLabel.text = editTextField.text
               }
               
        self.db.collection("user").document(email!).updateData([self.edit : self.textEdit])
        
    }
    
}



