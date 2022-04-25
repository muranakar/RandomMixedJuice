//
//  ViewController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak private var resultFruit1Label: UILabel!
    @IBOutlet weak private var resultFruit2Label: UILabel!
    @IBOutlet weak private var resultFruit3Label: UILabel!
    @IBOutlet weak private var resultFruit4Label: UILabel!
    @IBOutlet weak private var resultFruit5Label: UILabel!
    @IBOutlet weak private var randomCountSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var startStopButton: UIButton!
    var resultFruitLabels: [UILabel] {
        [
            resultFruit1Label,
            resultFruit2Label,
            resultFruit3Label,
            resultFruit4Label,
            resultFruit5Label
        ]
    }
    private var fruitsLines: [String] = []
    private var allResultFruits: [String] = []
    private var btnTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        configueViewStartStopButton()
        saveBarButtonItem.isEnabled = false
        guard let path = Bundle.main.path(
            forResource: "Fruits",
            ofType: "csv"
        ) else {
            print("csvファイルがない。")
            return
        }
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let csvLines = csvString.components(separatedBy: "\r\n")
        let newCVSLines = csvLines.filter { $0 != "" }
        fruitsLines = newCVSLines
    }

    @IBAction private func save(_ sender: Any) {
        // 選択されたボタン

        // 選択されたボタンから、Resultの値を取得

        // Resultの値を、配列に追加

        // その値を保存する。

        // 履歴を閲覧するボタンは別のボタンで画面遷移
    }

    @IBAction private func randomStart(_ sender: Any) {
        if !startStopButton.isSelected {
            startStopButton.isSelected = true
            saveBarButtonItem.isEnabled = false
            resultFruitLabels.forEach { $0.text = "" }
            self.btnTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(self.changefruit),
                userInfo: nil, repeats: true
            )
        } else {
            saveBarButtonItem.isEnabled = true
            startStopButton.isSelected = false
            self.btnTimer!.invalidate()
            configureViewLabel()
            print(allResultFruits)
        }
    }

    @objc func changefruit() {
        allResultFruits = []
        pickupRandomFruitsAndConfigureResultFruit1(elements: randomCountSegmentedControl.selectedSegmentIndex + 1)
        configureViewLabel()
    }

    func pickupRandomFruitsAndConfigureResultFruit1(elements: Int) {
        var count = 0
        allResultFruits = Set(fruitsLines).pickup(elements: elements)
        allResultFruits.forEach { resultFruit in
            resultFruitLabels[count].text = resultFruit
            count += 1
        }
    }

    private func configureViewLabel() {
        var count = 0
        resultFruitLabels.forEach { label in
            label.text = ""
        }
        allResultFruits.forEach { resultFruit in
            resultFruitLabels[count].text = resultFruit
            count += 1
        }
    }

    private func configueViewStartStopButton() {
        startStopButton.setTitle("スタート", for: .normal)
        startStopButton.setTitle("ストップ", for: .selected)
    }
}

private extension Set {
    func pickup(elements number: Int) -> [Element] {
        guard number < count else {
            return shuffled()
        }
        var results = Set(), temp = self
        while results.count < number, let element = temp.randomElement() {
            results.insert(element)
            temp.remove(element)
        }
        return Array(results)
    }
}
