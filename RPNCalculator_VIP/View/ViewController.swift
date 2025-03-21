//
//  ViewController.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 19/03/25.
//

import UIKit

protocol CalculatorViewProtocol: AnyObject {
    func showResult(value: String, expression: String?)
}

class ViewController: UIViewController {
    // MARK: - Properties
    var interactor: CalculatorInteractorProtocol
    
    // MARK: - UI Components
    private let stackLabel: CalculatorLabel = {
        let label = CalculatorLabel(
            text: "0",
            textColor: .white,
            font: .boldSystemFont(ofSize: 60)
        )
        return label
    }()
    
    private let expressionLabel: CalculatorLabel = {
        let label = CalculatorLabel(
            text: "",
            textColor: .gray,
            font: .boldSystemFont(ofSize: 30)
        )
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let portraitStructure: [[CalculatorButtonsEnum]] = [
        [.backspace, .openParenthesis, .closeParenthesis , .divide],
        [.seven, .eight, .nine, .multiplyX],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.allClear, .zero, .dot, .equal]
    ]
    
    private let landscapeStructure: [[CalculatorButtonsEnum]] = [
        [.seven, .eight, .nine, .backspace, .divide],
        [.four, .five, .six, .openParenthesis, .multiplyX],
        [.one, .two, .three, .closeParenthesis, .minus],
        [.allClear, .zero, .dot, .equal, .plus]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    init(interactor: CalculatorInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        setupButtons()
        setupLabels()
    }
    
    private func setupButtons() {
        let buttonStack = CalculatorStackView(axis: .vertical)
        view.addSubview(buttonStack)
        
        for row in portraitStructure {
            let rowStack = CalculatorStackView(axis: .horizontal)
            
            for title in row {
                let button = CalculatorButton(title: title)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                rowStack.addArrangedSubview(button)
            }
            buttonStack.addArrangedSubview(rowStack)
        }
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            buttonStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2)
        ])
    }
    
    private func setupLabels() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIScreen.main.bounds.height / 2 - 20),
            scrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 10)
        ])
        
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackLabel)
        
        NSLayoutConstraint.activate([
            stackLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackLabel.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor),
            stackLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor)
        ])
        
        view.addSubview(expressionLabel)
        
        NSLayoutConstraint.activate([
            expressionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            expressionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            expressionLabel.bottomAnchor.constraint(equalTo: stackLabel.topAnchor, constant: -5),
         //   expressionLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
        ])
    }
    
    // MARK: - Button Action
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, !title.isEmpty else { return }
      //  viewModel.handleButtonTap(CalculatorButtonsEnum(rawValue: title) ?? .allClear)
      //  updateDisplay()
        
        let titleBtn = CalculatorButtonsEnum(rawValue: title) ?? .allClear
        
        print(titleBtn)
        
        guard let txtstr = stackLabel.text else {return}
        
        interactor.processResult(val: titleBtn, currentInput: txtstr)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: CalculatorViewProtocol {
    
    func showResult(value: String, expression: String?) {
        stackLabel.text = value
        if let expression {
            self.expressionLabel.text = expression
        } else {
            self.expressionLabel.text = ""
        }
    }
    
    
}
