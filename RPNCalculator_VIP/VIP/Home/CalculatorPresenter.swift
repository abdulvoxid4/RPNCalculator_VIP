//
//  Presenter.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import Foundation

protocol CalculatorPresenterProtocol {
    func presentResult(value: String, expression: String?)

}

final class CalculatorPresenter: CalculatorPresenterProtocol {
   
    weak var view: CalculatorViewProtocol?
    
    func presentResult(value: String, expression: String?) {
        
        view?.showResult(value: value, expression: expression)
    }
    
}

