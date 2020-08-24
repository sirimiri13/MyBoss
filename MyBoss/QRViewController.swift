//
//  QRViewController.swift
//  MyBoss
//
//  Created by Huong Lam on 6/3/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD


class QRViewController: UIViewController {
    let titleLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 157, y: 50, width: 100, height: 25))
        label.text = "YOUR OR"
        label.textColor = .systemBlue
        return label
    }()
    
    @IBOutlet weak var QRImage: UIImageView!
    let db = Firestore.firestore()
    var qrImageURL: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayQR()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "YOUR QR"

    }
    
    
    
    // lây QR từ fb về show ra view
    func displayQR(){
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        let acc = Auth.auth().currentUser?.email
        DispatchQueue.global(qos: .background).async {
            self.db.collection("user").document(acc!).getDocument { (qSnap , err) in
                self.qrImageURL = qSnap?.data()!["QR"] as! String
                let ref = Storage.storage().reference(forURL: self.qrImageURL)
                ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                    if error == nil {
                        hud.dismiss(animated: true)
                        DispatchQueue.main.async {
                             self.QRImage.image = UIImage(data: data!)
                        }
                       
                    }
                }
            }
        }
        
        
    }
}




