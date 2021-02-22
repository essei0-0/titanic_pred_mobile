//
//  B_ViewController.swift
//  ml_app
//
//  Created by Takada Essei on 2021/02/18.
//  Copyright © 2021 Takada Essei. All rights reserved.
//

import UIKit

class B_ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!

    // 1. 遷移先に渡したい値を格納する変数を用意する
    var outputValues : [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        outputLabel.text = "\(outputValues["name"] as! String) は\(outputValues["survive"] as! String)"
    }
}
