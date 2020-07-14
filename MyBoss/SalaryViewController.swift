//
//  SalaryViewController.swift
//  MyBoss
//
//  Created by Huong Lam on 07/13/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD

struct Salary{
    var month: String
    var salary: Int
}
class SalaryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableSalaryView: UITableView!
    var listSalary : [Salary] = []
    let auth = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTable()
       // print(self.listSalary)
        self.tableSalaryView.reloadData()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    func setTable(){
        db.collection("attendance").document(auth!).collection("Salary").getDocuments { (snap, err) in
            for month in snap!.documents{
                let salary = Salary(month: month.documentID, salary: month.data()["Salary"] as! Int)
                self.listSalary.append(salary)
//                print(self.listSalary)
                 self.tableSalaryView.reloadData()
            }
        }
       
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSalary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryCell", for: indexPath)
        cell.textLabel?.text = listSalary[indexPath.row].month
        let detail = String(listSalary[indexPath.row].salary)
        cell.detailTextLabel?.textColor = .red
        cell.detailTextLabel?.text = detail
        return cell
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
