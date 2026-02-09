//
//  ViewController.swift
//  ios-dynamic
//
//  Created by Fahad on 06/02/2022.
//

import UIKit
import ATGRDB
import SQLite3

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! print(DatabaseQueue().read { try String.fetchOne($0, sql: "SELECT 'Hello world!'")! })
        _ = sqlite3_libversion_number()
    }
}

