//
//  Presenter.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import Foundation

protocol CalculatorPresenterProtocol {
    
    func presnetResult(value: String, expression: String?)
    
}


final class CalculatorPresenter: CalculatorPresenterProtocol {
    
    weak var view: CalculatorViewProtocol?
    
    func presnetResult(value: String, expression: String?) {
        
        view?.showResult(value: value, expression: expression)
    }
    
    
}

