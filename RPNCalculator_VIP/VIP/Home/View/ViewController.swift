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
    // MARK: - Dependencies
    var interactor: CalculatorInteractorProtocol
    var router: CalculatorRouter?
    
    // MARK: - UI Components
    private let buttonsStackView = CalculatorStackView(axis: .vertical)
    
    private let stackLabel: CalculatorLabel = {
        let label = CalculatorLabel(
            text: "0",
            textColor: .labelColor,
            font: .boldSystemFont(ofSize: 60) // 60
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
    
    private let historyButton: UIButton = {
        let historyButton = UIButton(type: .system)
        historyButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        historyButton.tintColor = .orange
        return historyButton
    }()
    
    private let portraitStructure: [[CalculatorButtonsEnum]] = [
        [.backspace, .open, .close , .divide],
        [.seven, .eight, .nine, .multiplyX],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.allClear, .zero, .dot, .equal]
    ]

    // MARK: - Lifecycle function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let historyBarButtonItem = UIBarButtonItem(customView: historyButton)
            navigationItem.leftBarButtonItem = historyBarButtonItem
        
        setupUI()
    }
    
    //MARK: - INIT
    init(interactor: CalculatorInteractorProtocol, router: CalculatorRouter) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .viewBackgroundColor
       
        setupStackButtons() // Sets up StackView buttons
      
        setupConstraints() // Sets up constraints for all UI elements
    
        // When historyButton tapped
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
    }
    
    private func setupStackButtons() {
        view.addSubview(buttonsStackView)
        
        for row in portraitStructure {
            let rowStack = CalculatorStackView(axis: .horizontal)
            
            for title in row {
                let button = CalculatorButton(title: title)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                rowStack.addArrangedSubview(button)
            }
            buttonsStackView.addArrangedSubview(rowStack)
        }
        
    }
    
    private func setupConstraints() {
        buttonsStackView.setConstraints(.left, view: view, constant: 20)
        buttonsStackView.setConstraints(.right, view: view, constant: 20)
        buttonsStackView.setConstraints(.bottomLessThan, view: view, constant: 20)
        buttonsStackView.setConstraints(.height, constant: UIScreen.main.bounds.height / 2 )
        
        view.addSubview(scrollView)
        scrollView.setConstraints(.left, view: view, constant: 30)
        scrollView.setConstraints(.right, view: view, constant: 30)
        scrollView.setConstraints(.bottomToTop, view: buttonsStackView, constant: 20)
        scrollView.setConstraints(.height, constant: UIScreen.main.bounds.height / 10)
        
        scrollView.addSubview(stackLabel)
        stackLabel.setConstraints(.top, view: scrollView)
        stackLabel.setConstraints(.bottom, view: scrollView)
        stackLabel.setConstraints(.right, view: scrollView)
        stackLabel.setConstraints(.leftGreaterThan, view: scrollView)
        stackLabel.setConstraints(.widthGreaterThan, view: scrollView)
        
        view.addSubview(expressionLabel)
        expressionLabel.setConstraints(.left, view: view, constant: 30)
        expressionLabel.setConstraints(.right, view: view, constant: 30)
        expressionLabel.setConstraints(.bottomToTop, view: stackLabel, constant: 5)
       
    }

    
    // MARK: - Button Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, !title.isEmpty else { return }
        
        let titleBtn = CalculatorButtonsEnum(rawValue: title) ?? .allClear
            
        guard let txtstr = stackLabel.text else {return}
        interactor.processResult(val: titleBtn, currentInput: txtstr)
    }
    
    @objc private func historyButtonTapped() {
        router?.navigateToHistory()  // Calls the router to show HistoryVC
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
        updateDisplay()
    }
    
    private func updateDisplay() {
        guard let currentInput = stackLabel.text else { return }
        
        let textSize = (currentInput as NSString).size(withAttributes: [.font: stackLabel.font as Any])
        let labelWidth = max(textSize.width, scrollView.frame.width)

        stackLabel.frame.size.width = labelWidth
        
        scrollView.contentSize = CGSize(width: labelWidth, height: scrollView.frame.height)
        
        let maxOffsetX = max(labelWidth - scrollView.frame.width, 0)
        scrollView.setContentOffset(CGPoint(x: maxOffsetX, y: 0), animated: false)
    }
    
}

