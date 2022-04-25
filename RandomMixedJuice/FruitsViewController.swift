//
//  FruitsViewController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/25.
//

import UIKit

class FruitsViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FruitsViewController: UITableViewDelegate {
}

extension FruitsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FruitsTableViewCell
        cell.configureLabelText(text: "tatata")
        return cell
    }
}
