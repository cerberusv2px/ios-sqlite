//
//  ViewController.swift
//  SQLiteFirst
//
//  Created by Sujin Shrestha on 9/13/18.
//  Copyright © 2018 Sujin Shrestha. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var db: OpaquePointer?
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    
    @IBOutlet weak var tableUser: UITableView!
    
    var userList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableUser.delegate = self
        self.tableUser.dataSource = self
        self.tableUser.tableFooterView = UIView()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("User.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
        createTable()
        showData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "userCell")
        let user: User = userList[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    @IBAction func button_save(_ sender: UIButton) {
        let name = textFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = textFieldAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO Users (name, address) VALUES (?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, address, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding address: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting user: \(errmsg)")
            return
        }
        
        //emptying the textfields
        textFieldName.text=""
        textFieldAddress.text=""
        showData()
        print("User saved..")
    }
    
    private func showData() {
        userList.removeAll()
        let queryString = "SELECT * FROM Users"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let address = String(cString: sqlite3_column_text(stmt, 2))
            self.userList.append(User(id: Int(id), name: String(describing: name), address: String(describing: address)))
        }
        
        DispatchQueue.main.async {
            print("reloading data....")
            self.tableUser.reloadData()
        }
        
    }
    
    
    private func createTable() {
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Users( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, address TEXT)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("Error createing table: \(errMsg)")
        }
    }
    
}

