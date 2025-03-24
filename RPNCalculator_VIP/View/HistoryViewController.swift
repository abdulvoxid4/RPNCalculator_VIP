//
//  HistoryViewController.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 22/03/25.
//

import UIKit

protocol HistoryViewProtocol: AnyObject {
    func updateHistory(with calculations: [CalculationHistoryEntity])
}

class HistoryViewController: UIViewController {
    // MARK: - Properties
    var interactor: HistoryInteractorProtocol
    var router: HistoryRouter?
    
    private var historyData: [(expression: String, result: String)] = []
    
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
        
        interactor.didFetchHistory()
    }
    
    init(interactor: HistoryInteractorProtocol, router: HistoryRouter) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
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
    
    func updateHistory(_ history: [(expression: String, result: String)]) {
            self.historyData = history
                
            tableView.reloadData()
        }
    
    @objc private func doneTapped() {
            router?.dismissHistory()
        }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
       
        let entry = historyData[indexPath.row]
        cell.configure(expression: entry.expression, result: entry.result)
        print(historyData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
