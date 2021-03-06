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
    let hud = JGProgressHUD(style: .dark)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 250, width: 414, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        self.view.addSubview(calendar)
        self.calendar = calendar
        calendar.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "MY BOSS"
        hud.show(in: self.view)
        DispatchQueue.global(qos: .background)
        listDay.removeAll()
        hud.dismiss(animated: true)
        DispatchQueue.main.async {
            self.getDays()
        }
        
        
    }
    
    // lấy ngày làm việc của nhân viên đang đăng nhập
    func getDays(){
        
        db.collection("attendance").document(auth!).collection("days").getDocuments { (snap, err) in
            for doc in snap!.documents{
                let date = doc.data()["date"] as! NSArray
                for day in date {
                    let temp = day as! String
                    if (temp != ""){
                        self.listDay.append(temp)
                        self.calendar.reloadData()
                    }
                }
            }
            
        }
        
        
    }
    
    // format ngày
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    // đánh dấu ngày làm lên lịch
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        calendar.appearance.eventDefaultColor = .red
        let dateString = self.dateFormatter2.string(from: date)
        
        if self.listDay.contains(dateString) {
            return 1
        }
        
        return 0
    }
 
    
}

