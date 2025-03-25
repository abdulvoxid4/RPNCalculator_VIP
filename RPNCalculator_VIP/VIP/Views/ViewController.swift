//
//  ViewController.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 19/03/25.
//

import UIKit

protocol CalculatorViewProtocol: AnyObject {
    func showResult(value: String, expression: String?)
    func setStackView(from structure: [[CalculatorButtonsEnum]], isRemoveAllEmentsFromStack: Bool)
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

    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let historyBarButtonItem = UIBarButtonItem(customView: historyButton)
            navigationItem.leftBarButtonItem = historyBarButtonItem
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        let isLandscapeMode = UIDevice.current.orientation.isLandscape
        interactor.didChangedAppOrientation(to: isLandscapeMode ? .landscape : .portrait)
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
        view.addSubview(expressionLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(stackLabel)
        view.addSubview(buttonsStackView)

        setupConstraints()
        
        interactor.firstViewDidLoad()
        
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)

    }
    
    private func setupConstraints() {
        expressionLabel.setConstraints(.left, view: view, constant: 30)
        expressionLabel.setConstraints(.right, view: view, constant: 30)
        expressionLabel.setConstraints(.bottomToTop, view: stackLabel, constant: 5)
        
        scrollView.setConstraints(.left, view: view, constant: 30)
        scrollView.setConstraints(.right, view: view, constant: 30)
        scrollView.setConstraints(.bottomToTop, view: buttonsStackView, constant: 20)
        scrollView.setConstraints(.height, constant: UIScreen.main.bounds.height / 10)
        
        stackLabel.setConstraints(.top, view: scrollView)
        stackLabel.setConstraints(.bottom, view: scrollView)
        stackLabel.setConstraints(.right, view: scrollView)
        stackLabel.setConstraints(.leftGreaterThan, view: scrollView)
        stackLabel.setConstraints(.widthGreaterThan, view: scrollView)
    
        buttonsStackView.setConstraints(.left, view: view, constant: 20)
        buttonsStackView.setConstraints(.right, view: view, constant: 20)
        buttonsStackView.setConstraints(.bottomLessThan, view: view, constant: 20)
        buttonsStackView.setConstraints(.height, constant: UIScreen.main.bounds.height / 2 )
        
    }
    
    private func resetFullView() {
        buttonsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        for subview in view.subviews {
            subview.removeConstraints(subview.constraints)
        }
        for subview in scrollView.subviews {
            subview.removeConstraints(subview.constraints)
        }
        
        setupConstraints()
    }

    
    // MARK: - Button Action
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
   
    func setStackView(from structure: [[CalculatorButtonsEnum]], isRemoveAllEmentsFromStack: Bool) {
        if isRemoveAllEmentsFromStack == true {
            resetFullView()
        }
        
        for row in structure {
            let rowStack = CalculatorStackView(axis: .horizontal)
            
            for title in row {
                let button = CalculatorButton(title: title)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                rowStack.addArrangedSubview(button)
            }
            buttonsStackView.addArrangedSubview(rowStack)
        }
    }
    
    
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
