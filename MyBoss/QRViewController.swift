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
import ParticlesLoadingView


class QRViewController: UIViewController {
    //var image = UIImage()
    
    let titleLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 157, y: 50, width: 100, height: 25))
        label.text = "YOUR OR"
        label.textColor = .systemBlue
        return label
    }()
    lazy var loadingView: ParticlesLoadingView = {
          let x = UIScreen.main.bounds.size.width / 2 - (75 / 2) - 200 // 🙈
          let y = UIScreen.main.bounds.size.height / 2 - (75 / 2) // 🙉
          let view = ParticlesLoadingView(frame: CGRect(x: 182, y: 300, width: 50, height: 50))
            view.particleEffect = .fire
          view.duration = 1.5
          view.particlesSize = 15.0
          view.clockwiseRotation = true
          view.layer.borderColor = UIColor.lightGray.cgColor
          view.layer.borderWidth = 1.0
          view.layer.cornerRadius = 15.0
          return view
      }()
    @IBOutlet weak var QRImage: UIImageView!
    let db = Firestore.firestore()
    var qrImageURL: String = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(loadingView)
        loadingView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.loadingView.stopAnimating()
            self.loadingView.removeFromSuperview()
            self.displayQR()
        }
       
    
    }
    func displayQR(){
        view.insertSubview(titleLabel, aboveSubview: view)
            let acc = Auth.auth().currentUser?.email
            db.collection("user").document(acc!).getDocument { (qSnap , err) in
                self.qrImageURL = qSnap?.data()!["QR"] as! String
                let ref = Storage.storage().reference(forURL: self.qrImageURL)
                ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                    if error == nil {
                        self.QRImage.image = UIImage(data: data!)
                    }
                }
            }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
