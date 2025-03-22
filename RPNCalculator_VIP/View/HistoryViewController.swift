//
//  HistoryViewController.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 22/03/25.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var router: HistoryRouter?
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        return doneButton
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .viewBackgroundColor
        settingTableView()
    }
    
    func settingTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    private func setupUI() {
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    
    @objc private func doneTapped() {
            router?.dismissHistory()
        }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = "salom"
        return cell
    }
    
    
}
