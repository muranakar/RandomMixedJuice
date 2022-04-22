//
//  ViewController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var resultFruit1Label: UILabel!
    @IBOutlet weak private var resultFruit2Label: UILabel!
    @IBOutlet weak private var resultFruit3Label: UILabel!
    @IBOutlet weak private var resultFruit4Label: UILabel!
    @IBOutlet weak private var resultFruit5Label: UILabel!
    @IBOutlet weak private var fruitCheckButton1: UIButton!
    @IBOutlet weak private var fruitCheckButton2: UIButton!
    @IBOutlet weak private var fruitCheckButton3: UIButton!
    @IBOutlet weak private var fruitCheckButton4: UIButton!
    @IBOutlet weak private var fruitCheckButton5: UIButton!
    private var isCheckfruit1 = false
    private var isCheckfruit2 = false
    private var isCheckfruit3 = false
    private var isCheckfruit4 = false
    private var isCheckfruit5 = false

    var fruitCheckButtons:[UIButton] {[
        fruitCheckButton1,
        fruitCheckButton2,
        fruitCheckButton3,
        fruitCheckButton4,
        fruitCheckButton5
    ]}
    var fruitIsChecks: [Bool] = [false,false,false,false,false]
    var fruitCheckArrayIndex: [Int] = Array(0...4)

    private var fruitButtonsNumberDictionary: [UIButton: Int] {
        [UIButton: Int](uniqueKeysWithValues: zip(fruitCheckButtons, fruitCheckArrayIndex))
    }
//
//    private var fruitIsChecksNumberDictionary: [Int: Bool] {
//        [Int: Bool](uniqueKeysWithValues: zip(fruitCheckNumber, fruitIsChecks))
//    }

    private var fruitsLines: [String] = []
    private var resultFruit1: String = ""
    private var resultFruit2: String = ""
    private var resultFruit3: String = ""
    private var resultFruit4: String = ""
    private var resultFruit5: String = ""

    var btnTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewButton()

        guard let path = Bundle.main.path(forResource:"Fruits", ofType:"csv") else {
            print("csvファイルがないよ")
            return
        }
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let csvLines = csvString.components(separatedBy: "\r\n")
        let newCVSLines = csvLines.filter { $0 != "" }
        fruitsLines = newCVSLines
    }


    @objc func changefruit(){
        resultFruit1 = fruitsLines.randomElement()!
        resultFruit2 = fruitsLines.randomElement()!
        resultFruit3 = fruitsLines.randomElement()!
        resultFruit4 = fruitsLines.randomElement()!
        resultFruit5 = fruitsLines.randomElement()!
        configureViewLabel()
    }

    @IBAction func randomStart(_ sender: Any) {
        self.btnTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,selector: #selector(self.changefruit), userInfo: nil, repeats: true)
    }

    @IBAction func randomStop(_ sender: Any) {
        self.btnTimer!.invalidate()
        configureViewLabel()
    }

    @IBAction func fruitCheckButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }


    func configureViewLabel() {
        resultFruit1Label.text = resultFruit1
        resultFruit2Label.text = resultFruit2
        resultFruit3Label.text = resultFruit3
        resultFruit4Label.text = resultFruit4
        resultFruit5Label.text = resultFruit5
    }

    func configureViewButton() {
        fruitCheckButtons.forEach { uiButton in
            uiButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            uiButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        }
    }
}

