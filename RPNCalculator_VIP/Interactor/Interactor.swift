//
//  Interactor.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import Foundation

protocol CalculatorInteractorProtocol {
    
    func processResult(val: CalculatorButtonsEnum, currentInput: String)
}


final class CalculatorInteractor: CalculatorInteractorProtocol {
    
    
    let rpnDataService = RPNDataService()
    
    var presenter: CalculatorPresenterProtocol
    
    
    init(presenter: CalculatorPresenterProtocol) {
        self.presenter = presenter
    }
    
    

    func processResult(val: CalculatorButtonsEnum, currentInput: String) {
        
        
       let processedRes = rpnDataService.directTo(currentInput: currentInput, title: val)
        
        presenter.presnetResult(value: processedRes)
    }
    
}


 
