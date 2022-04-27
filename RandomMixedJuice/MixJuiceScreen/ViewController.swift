//
//  ViewController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/22.
//

import UIKit

class ViewController: UIViewController {
    enum Mode {
        case initial
        case start
        case stop
    }

    private let fruitRepository: FruitRepositoryProtocol = RealmFruitRepository()

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var fruitTextField: UITextField!
    @IBOutlet weak private var fruitAddButton: UIButton!
    @IBOutlet weak private var resultFruit1Label: UILabel!
    @IBOutlet weak private var resultFruit2Label: UILabel!
    @IBOutlet weak private var resultFruit3Label: UILabel!
    @IBOutlet weak private var resultFruit4Label: UILabel!
    @IBOutlet weak private var resultFruit5Label: UILabel!
    @IBOutlet weak private var randomCountSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var startStopButton: UIButton!
    @IBOutlet weak private var fruitsListButton: UIButton!

    var resultFruitLabels: [UILabel] {
        [
            resultFruit1Label,
            resultFruit2Label,
            resultFruit3Label,
            resultFruit4Label,
            resultFruit5Label
        ]
    }
    private var loadedFruitNamesFromLocalDataBase: [String] {
        let fruits = fruitRepository.allLoadFruit(sortKey: "createdAt", ascending: true)
        return fruits.map { $0.name }
    }
    private var fruitNamesArray: [String] = []
    private var allResultFruits: [String] = []
    private var btnTimer: Timer!
    private var mode: Mode = .initial

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.alpha = 0.4
        configureInitialViewLabel()

        resetFruitNamesArrayAndAddFruitFromCsv()
    }

    @IBAction private func addFruit(_ sender: Any) {
        let fruitName = fruitTextField.text ?? ""
        if fruitName == "" { return }
        let fruit = Fruit(id: Fruit.ID(rawValue: UUID()), name: fruitName)
        fruitTextField.text = ""
        fruitRepository.addFruit(fruit: fruit)
        present(UIAlertController.addingCompletedFruit(), animated: true)
    }

    @IBAction private func randomStart(_ sender: Any) {
        switch mode {
        case .start:
            mode = .stop
            startStopButton.isSelected = false

            self.btnTimer!.invalidate()
            configureViewLabel()

            configureViewIsEnableButton()
            print(allResultFruits)
        case .initial, .stop:
            mode = .start
            startStopButton.isSelected = true

            configureViewIsEnableButton()

            resetFruitNamesArrayAndAddFruitFromCsv()
            resultFruitLabels.forEach { $0.text = "" }
            self.btnTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(self.changefruit),
                userInfo: nil, repeats: true
            )
        }
    }
    // MARK: - Segue
    @IBAction private func backToViewController(segue: UIStoryboardSegue) {
        resetFruitNamesArrayAndAddFruitFromCsv()
    }

    // MARK: - Method
    private func resetFruitNamesArrayAndAddFruitFromCsv() {
        fruitNamesArray = []
        if loadedFruitNamesFromLocalDataBase.isEmpty {
            loadFruitNamesFromCsv().forEach { fruitName in
                fruitRepository.addFruit(fruit: Fruit(id: Fruit.ID(rawValue: UUID()), name: fruitName))
            }
            fruitNamesArray = loadFruitNamesFromCsv()
        }
        fruitNamesArray.append(contentsOf: loadedFruitNamesFromLocalDataBase)
    }

    private func loadFruitNamesFromCsv() -> [String] {
        guard let path = Bundle.main.path(
            forResource: "Fruits",
            ofType: "csv"
        ) else {
            print("csvファイルがない。")
            fatalError()
        }
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let csvLines = csvString.components(separatedBy: "\r\n")
        let newCVSLines = csvLines.filter { $0 != "" }
        return newCVSLines
    }

    @objc func changefruit() {
        allResultFruits = []
        pickupRandomFruitsAndConfigureResultFruit(elements: randomCountSegmentedControl.selectedSegmentIndex + 1)
        configureViewLabel()
    }

    func pickupRandomFruitsAndConfigureResultFruit(elements: Int) {
        var count = 0
        allResultFruits = Set(fruitNamesArray).pickup(elements: elements)
        allResultFruits.forEach { resultFruit in
            resultFruitLabels[count].text = resultFruit
            count += 1
        }
    }

    private func configureInitialViewLabel() {
        resultFruitLabels.forEach { label in
            label.text = ""
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
    // MARK: - View

    private func configureViewIsEnableButton() {
        switch mode {
        case .initial, .stop:
            fruitAddButton.isEnabled = true
            fruitsListButton.isEnabled = true
        case .start:
            fruitAddButton.isEnabled = false
            fruitsListButton.isEnabled = false
        }
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
