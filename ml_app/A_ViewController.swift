//
//  A_ViewController.swift
//  ml_app
//
//  Created by Takada Essei on 2021/02/16.
//  Copyright © 2021 Takada Essei. All rights reserved.
//

import UIKit

class A_ViewController: UIViewController {

    @IBOutlet weak var embarked: UITextField!
    @IBOutlet weak var parch: UITextField!
    @IBOutlet weak var sibsp: UITextField!
    @IBOutlet weak var passengerid: UITextField!
    @IBOutlet weak var fare: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var cabin: UITextField!
    @IBOutlet weak var pclass: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var ticket: UITextField!
    var survive_key: String = ""
    let survive = ["0":"助からなかったでしょう","1":"生存していたでしょう"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // segueが動作することをViewControllerに通知するメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // segueのIDを確認して特定のsegueのときのみ動作させる
        if segue.identifier == "toBViewController" {
            let semaphore = DispatchSemaphore(value: 0)
            let url = URL(string: "http://0.0.0.0:5000/predict")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"      // Postリクエストを送る(このコードがないとGetリクエストになる)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    let params: [String: [String: Any]] = ["feature": [
                    "Age": [age.text],
                    "Cabin": [cabin.text],
                    "Embarked": [embarked.text],
                    "Fare": [fare.text],
                    "Name": [name.text],
                    "Parch": [parch.text],
                    "PassengerId": [passengerid.text],
                    "Pclass": [pclass.text],
                    "Sex": [sex.text],
                    "SibSp": [sibsp.text],
                    "Ticket": [ticket.text]]]
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
                        let jsonStr = String(bytes: jsonData, encoding: .utf8)!
                        print(jsonStr)
                        request.httpBody = jsonData
                    } catch (let e) {
                        print(e)
                    }
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        guard let data = data else { return }
            //            print("data: \(String(describing: data))")
            //            print("response: \(String(describing: response))")
            //            print("error: \(String(describing: error))")
                        do {
                            let object = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                            self.survive_key = object["prediction"] as! String
                            print(self.survive[self.survive_key])
                            
                        } catch let error {
                            print(error)
                        }
                        semaphore.signal()
                    }
                    
                    task.resume()
                    semaphore.wait()
            if name.text!.isEmpty {
                name.text = "その人"
            }
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? B_ViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.outputValues = ["name": name.text, "survive": survive[survive_key]]
        }
    }

    @IBAction func tapTransitionButton(_ sender: Any) {
        // 4. 画面遷移実行
        performSegue(withIdentifier: "toBViewController", sender: nil)
    }
    @IBAction func submit(_ sender: Any) {
        
    }
}
