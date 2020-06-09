//
//  CalendarViewController.swift
//  MyBoss
//
//  Created by Huong Lam on 6/1/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate,FSCalendarDataSource {
       fileprivate weak var calendarFS: FSCalendar!

    let bgImageView : UIImageView = {
               let imageView = UIImageView()
               imageView.translatesAutoresizingMaskIntoConstraints = false
               imageView.image = UIImage(named: "sky.jpg")
               imageView.contentMode = .scaleAspectFill
               return imageView
           }()
    let bgView : UIView = {
               let bgView = UIView()
               bgView.translatesAutoresizingMaskIntoConstraints = false
               bgView.backgroundColor = UIColor(displayP3Red: 9.0/255.0, green: 33.0/255.0, blue: 47.0/255.0, alpha: 1.0).withAlphaComponent(0.7)
               return bgView
           }()
    let calendarView : FSCalendar = {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 190, width: 414, height: 510))
        return calendar
        
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(bgImageView)
//        let calendar = FSCalendar()
//        view.addSubview(calendar)
//        self.calendar = calendar
       addingUIElements()
    }
    
    func addingUIElements(){
        // Background imageview
                   self.view.addSubview(bgImageView)
                   bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
                   bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
                   bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
                   bgImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        // Calendar view
        self.view.insertSubview(calendarView, aboveSubview: bgImageView)

    }

}
