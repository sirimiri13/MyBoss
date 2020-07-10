//
//  CalendarViewController.swift
//  MyBoss
//
//  Created by Huong Lam on 6/1/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FSCalendar
import JGProgressHUD

class CalendarViewController: UIViewController, FSCalendarDelegate,FSCalendarDataSource {
    fileprivate weak var calendar: FSCalendar!
    var listDay : [String] = []
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser?.email
    //
    //    let bgImageView : UIImageView = {
    //               let imageView = UIImageView()
    //               imageView.translatesAutoresizingMaskIntoConstraints = false
    //               imageView.image = UIImage(named: "sky.jpg")
    //               imageView.contentMode = .scaleAspectFill
    //               return imageView
    //           }()
    //    let bgView : UIView = {
    //               let bgView = UIView()
    //               bgView.translatesAutoresizingMaskIntoConstraints = false
    //               bgView.backgroundColor = UIColor(displayP3Red: 9.0/255.0, green: 33.0/255.0, blue: 47.0/255.0, alpha: 1.0).withAlphaComponent(0.7)
    //               return bgView
    //           }()
    //    let calendarView : FSCalendar = {
    //        let calendar = FSCalendar(frame: CGRect(x: 0, y: 190, width: 414, height: 510))
    //        return calendar
    //
    //    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 250, width: 414, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        let hud = JGProgressHUD(style: .dark)
     
            self.view.addSubview(calendar)
            self.calendar = calendar
        hud.show(in: self.view)
             DispatchQueue.global(qos: .background).async {
            hud.dismiss(animated: true)
            DispatchQueue.main.async {
                self.getDays()
            }
        }
        //  getDays()
    }
    
    
    func getDays(){
        
        db.collection("attendance").document(auth!).collection("days").getDocuments { (snap, err) in
            for doc in snap!.documents{
                let date = doc.data()["date"] as! NSArray
                for day in date {
                    let temp = day as! String
                    if (temp != ""){
                        self.listDay.append(temp)
                    }
                }
            }
            
        }
        
        
    }
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        calendar.appearance.eventDefaultColor = .red
        let dateString = self.dateFormatter2.string(from: date)
        
        if self.listDay.contains(dateString) {
            return 1
        }
        
        return 0
    }
    //    func addingUIElements(){
    //        // Background imageview
    //                   self.view.addSubview(bgImageView)
    //                   bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
    //                   bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
    //                   bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
    //                   bgImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
    //        // Calendar view
    //        self.view.insertSubview(calendarView, aboveSubview: bgImageView)
    //
    //    }
    
}
