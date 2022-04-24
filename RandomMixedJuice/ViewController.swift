//
//  ViewController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/22.
//

import UIKit

class ViewController: UIViewController {
    enum RandomState {
        case start
        case stop
    }

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
    @IBOutlet weak private var startButton: UIButton!
    @IBOutlet weak private var stopButton: UIButton!

    var fruitCheckButtons: [UIButton] {
        [
            fruitCheckButton1,
            fruitCheckButton2,
            fruitCheckButton3,
            fruitCheckButton4,
            fruitCheckButton5
        ]
    }

    var resultFruitLabels: [UILabel] {
        [
            resultFruit1Label,
            resultFruit2Label,
            resultFruit3Label,
            resultFruit4Label,
            resultFruit5Label
        ]
    }

    var resultFruits: [String] {
        [
            resultFruit1,
            resultFruit2,
            resultFruit3,
            resultFruit4,
            resultFruit5
        ]
    }
    var fruitIsChecks: [Bool] = [false, false, false, false, false]
    var fruitCheckArrayIndex: [Int] = Array(0...4)

    private var fruitButtonsNumberDictionary: [UIButton: String] {
        [UIButton: String](uniqueKeysWithValues: zip(fruitCheckButtons, resultFruits))
    }
    private var fruitButtonsAndResultLabelDictionary: [UIButton: UILabel] {
        [UIButton: UILabel](uniqueKeysWithValues: zip(fruitCheckButtons, resultFruitLabels))
    }

    private var fruitsLines: [String] = []
    private var resultFruit1: String = ""
    private var resultFruit2: String = ""
    private var resultFruit3: String = ""
    private var resultFruit4: String = ""
    private var resultFruit5: String = ""
    var allResultFruits: [String] = []
    var resultFruitsIsSelected: [String] = []


    var btnTimer: Timer!

    var randomState: RandomState = .stop

    var isCheckCount: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewButton()
        guard let path = Bundle.main.path(forResource: "Fruits", ofType: "csv" ) else {
            print("csvファイルがないよ")
            return
        }
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let csvLines = csvString.components(separatedBy: "\r\n")
        let newCVSLines = csvLines.filter { $0 != "" }
        fruitsLines = newCVSLines
    }

    @IBAction func save(_ sender: Any) {
        //選択されたボタン

        //選択されたボタンから、Resultの値を取得

        //Resultの値を、配列に追加

        //その値を保存する。

        //履歴を閲覧するボタンは別のボタンで画面遷移

        resultFruitsIsSelected
    }

    @IBAction private func randomStart(_ sender: Any) {
        randomState = .start
        configueButtonIsEnable()
        switch randomState {
        case .start:
            self.btnTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(self.changefruit),
                userInfo: nil, repeats: true
            )
        case .stop:
            break
        }
    }

    @objc func changefruit() {
        var count = 1
        allResultFruits = []
        while count < 6 {
            let randomFruit = fruitsLines.randomElement()!
            let filterResultsFruit = allResultFruits.filter { randomFruit == $0 }
            if filterResultsFruit.isEmpty {
                allResultFruits.append(randomFruit)
                count += 1
            }
        }
        resultFruit1 = allResultFruits[0]
        resultFruit2 = allResultFruits[1]
        resultFruit3 = allResultFruits[2]
        resultFruit4 = allResultFruits[3]
        resultFruit5 = allResultFruits[4]
        configureViewLabel()
    }

    @IBAction private func randomStop(_ sender: Any) {
        randomState = .stop
        configueButtonIsEnable()
        switch randomState {
        case .start:
            break
        case .stop:
            self.btnTimer!.invalidate()
            configureViewLabel()
        }
    }

    @IBAction private func fruitCheckButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if !sender.isSelected {
            fruitButtonsAndResultLabelDictionary[sender]?.isHidden = true
        } else {
            fruitButtonsAndResultLabelDictionary[sender]?.isHidden = false
        }
    }
    private func configureViewLabel() {
        resultFruit1Label.text = resultFruit1
        resultFruit2Label.text = resultFruit2
        resultFruit3Label.text = resultFruit3
        resultFruit4Label.text = resultFruit4
        resultFruit5Label.text = resultFruit5
    }

    private func configureViewButton() {
        fruitCheckButtons.forEach { uiButton in
            uiButton.isSelected = true
            uiButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            uiButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        }
    }
    private func configueButtonIsEnable() {
        switch randomState {
        case .start:
            startButton.isEnabled = false
            stopButton.isEnabled = true
        case .stop:
            startButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
}
