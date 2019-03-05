//
//  SecondViewController.swift
//  SampleTest_midterm
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Saiwarun.Y. All rights reserved.
//

import UIKit
import SQLite3

class SecondViewController: UIViewController {
    let fileName = "db2.sqlite"
    let fileManager = FileManager.default
    let dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    
    var arr: [String] = []
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func AddTab(_ sender: Any) {
        let alert = UIAlertController(
            title: "Input result",
            message: "ใส่ข้อมูลให้ครบทุกช่อง",
            preferredStyle: .alert
        )
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "พอใจ/ปานกลาง/ไม่พอใจ"
            tf.font = UIFont.systemFont(ofSize: 18)
            tf.keyboardType = .phonePad
        })
        
        let btCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        let btOK = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                let result = alert.textFields!.first!.text!
                
                self.sql = "insert into test values (null, '\(self.arr[0])', '\(self.arr[1])', '\(self.arr[2])','\(result)')"
                sqlite3_exec(self.db, self.sql, nil, nil, nil)
            
                self.select()
        } )
        alert.addAction(btCancel)
        alert.addAction(btOK)
        present(alert, animated:true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbURL = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
            ).appendingPathComponent(fileName)
        let openDb = sqlite3_open(dbURL.path, &db)
        if openDb != SQLITE_OK {
            print("Opening Database Error!")
            return
        }
        sql = "CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, product TEXT, position TEXT, result TEXT)"
        let createTb = sqlite3_exec(db, sql, nil, nil, nil)
        if createTb != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db))
            print(err)
        }
        sql = "INSERT INTO test (id, date, product, position, result) VALUES ('1', '24/12/2019', 'food', 'aaaa', 'Great')"
        sqlite3_exec(db, sql, nil, nil, nil)
        
        select()
    }
    func select(){
        sql = "SELECT * FROM test"
        sqlite3_prepare(db, sql, -1, &pointer, nil)
        textView.text = ""
        var id: Int32
        var d: String
        var pr: String
        var po: String
        var result: String
        
        while(sqlite3_step(pointer) == SQLITE_ROW){
            id = sqlite3_column_int(pointer, 0)
            textView.text?.append("id: \(id)\n")
            
            d = String(cString: sqlite3_column_text(pointer, 1))
            textView.text?.append("date: \(d)\n")
            
            pr = String(cString: sqlite3_column_text(pointer, 2))
            textView.text?.append("product: \(pr)\n")
            
            po = String(cString: sqlite3_column_text(pointer, 3))
            textView.text?.append("position: \(po)\n")
            
            result = String(cString: sqlite3_column_text(pointer, 4))
            textView.text?.append("result: \(result)\n\n")
        }
    }
}
