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
    func changePosition(to orientation: AppOrientation) {
        <#code#>
    }
    
    func setStackView() {
        <#code#>
    }
    
    
    weak var view: CalculatorViewProtocol?
    
    func presentResult(value: String, expression: String?) {
        
        view?.showResult(value: value, expression: expression)
    }
    
    
}

