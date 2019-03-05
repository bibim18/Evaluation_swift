//
//  ViewController.swift
//  SampleTest_midterm
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Saiwarun.Y. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    @IBOutlet weak var selectedDateLb: UILabel!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var product: UITextField!
    
    @IBAction func nextTab(_ sender: Any) {
        let currentDate = date.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "dd/MM/YYYY"
        let currentDateText = myFormatter.string(from: currentDate)
        selectedDateLb.text = currentDateText
        
        self.performSegue(withIdentifier: "InputVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "InputVC"){
            let displayVC = segue.destination as! SecondViewController
            displayVC.arr = [selectedDateLb.text,product.text, position.text] as! [String]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDateLb.text = ""
    }


}

