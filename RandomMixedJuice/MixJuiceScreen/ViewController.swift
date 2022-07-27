//
//  ViewController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/22.
//

import UIKit
import GoogleMobileAds

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

    //　広告
    @IBOutlet weak private var bannerView: GADBannerView!  // 追加したUIViewを接続
    private var interstitial: GADInterstitialAd?


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
        configureAdBannar()
        imageView.alpha = 0.1
        configureViewInitialLabel()
        configureViewStartStopButton()
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
            self.btnTimer!.invalidate()
            configureViewLabel()
            configureViewStartStopButton()
            configureViewIsEnableButton()
            showGoogleIntitialAdOnceInThreeTimes()
        case .initial, .stop:
            mode = .start
            configureInterstitialAd()
            configureViewStartStopButton()
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
    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.bannerID)"
        bannerView.rootViewController = self

        // 広告読み込み
        bannerView.load(GADRequest())
    }
    // MARK: - 広告関係のメソッド
    private func configureInterstitialAd() {
        // インタースティシャル広告
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: GoogleAdID.interstitialID,
            request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            }
        )
    }

    //　Google広告を2回に表示するメソッド
    func showGoogleIntitialAdOnceInThreeTimes() {
        // 広告を2回に、１回表示する処理
        let adNum = GADRepository.processAfterAddGADNumPulsOneAndSaveGADNum()
        if adNum % 2 == 0 && interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        }
    }
    // MARK: - View
    private func configureViewInitialLabel() {
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
    private func configureViewStartStopButton() {
        switch mode {
        case .initial, .stop :
            startStopButton.setTitle("スタート", for: .normal)
        case .start:
            startStopButton.setTitle("ストップ", for: .normal)
        }
    }

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

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    }
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
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
