//
//  FruitsViewController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/25.
//

import UIKit

class FruitsViewController: UIViewController {
    private let repository: FruitRepositoryProtocol = RealmFruitRepository()
    @IBOutlet weak private var tableView: UITableView!
    private var fruits: [Fruit] {
        repository.allLoadFruit(sortKey: "createdAt", ascending: false)
    }

    @IBAction private func reset(_ sender: Any) {
        present(UIAlertController.resetFruit(
            reset: { [weak self]  ( _ : UIAlertAction!) in
                self?.removeAllFruitsFromLocalDatabaseAndAddFruitFromCsv()
                self?.tableView.reloadData()
            }),
                animated: true
        )
    }
    // MARK: - Method
    private func removeAllFruitsFromLocalDatabaseAndAddFruitFromCsv() {
        fruits.forEach { fruit in
            repository.removeFruit(fruit: fruit)
        }
        loadFruitNamesFromCsv().forEach { fruitName in
            repository.addFruit(fruit: Fruit(id: Fruit.ID(rawValue: UUID()), name: fruitName))
        }
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
}

extension FruitsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FruitsTableViewCell
        let fruitNames = fruits.map { $0.name }
        cell.configureLabelText(text: fruitNames[indexPath.row])
        return cell
    }
}
extension FruitsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let fruit = fruits[indexPath.row]
        repository.removeFruit(fruit: fruit)
        tableView.reloadData()
    }
}
