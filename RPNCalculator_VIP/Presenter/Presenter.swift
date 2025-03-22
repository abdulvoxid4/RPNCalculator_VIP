//
//  Presenter.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import Foundation

protocol CalculatorPresenterProtocol {
    
    func presentResult(value: String, expression: String?)
    func setStackView()
    func changePosition(to orientation: AppOrientation)
    
}


final class CalculatorPresenter: CalculatorPresenterProtocol {
    
    weak var view: CalculatorViewProtocol?
    
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

    // When app launched for the first time
    func setStackView() {
        view?.setStackView(from: portraitStructure, isRemoveAllEmentsFromStack: false)
    }
    
    // When Orientation is changed
    func changePosition(to orientation: AppOrientation) {
        let structure = orientation == .landscape ? landscapeStructure : portraitStructure
        
        view?.setStackView(from: structure, isRemoveAllEmentsFromStack: true)
    }
    
    
    
    func presentResult(value: String, expression: String?) {
        
        view?.showResult(value: value, expression: expression)
    }
    
    
}

