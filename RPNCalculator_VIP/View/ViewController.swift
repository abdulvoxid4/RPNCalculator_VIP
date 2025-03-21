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
            textColor: .labelColor,
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
    
//    private let historyButton: CalculatorButton = {
//        let button = CalculatorButton(title: .allClear, imageName: "s" )
        
 //   }()
    
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
        view.backgroundColor = .viewBackgroundColor
        setupButtonStack()
        setupUIElments()
    }
    
    private func setupButtonStack() {
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
    
        buttonStack.setConstraints(.left, view: view, constant: 30)
        buttonStack.setConstraints(.right, view: view, constant: 30)
        buttonStack.setConstraints(.bottomLessThan, view: view, constant: 20)
        buttonStack.setConstraints(.height, constant: ScreenSize.height / 2)
    }
    
    private func setupUIElments() {
        view.addSubview(scrollView)
        
        scrollView.setConstraints(.left, view: view, constant: 30)
        scrollView.setConstraints(.right, view: view, constant: 30)
        scrollView.setConstraints(.bottomSafe, view: view, constant: -ScreenSize.height / 2 - 20)
        scrollView.setConstraints(.height, constant: ScreenSize.height / 10)
        
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
    
    // MARK: - Button Action
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, !title.isEmpty else { return }
        
        let titleBtn = CalculatorButtonsEnum(rawValue: title) ?? .allClear
            
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
