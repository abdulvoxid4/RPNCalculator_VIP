//
//  Interactor.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import Foundation

protocol CalculatorInteractorProtocol {
    
    func processResult(val: CalculatorButtonsEnum, currentInput: String)
    func didChangedAppOrientation(to orientation: AppOrientation)
    func firstViewDidLoad()
}


final class CalculatorInteractor: CalculatorInteractorProtocol {
    // MARK: - Dependencies
    let rpnDataService = RPNDataService()
    
    var presenter: CalculatorPresenterProtocol
    
    // MARK: - Init
    init(presenter: CalculatorPresenterProtocol) {
        self.presenter = presenter
    }
    
    

    func processResult(val: CalculatorButtonsEnum, currentInput: String) {
        
        
       let processedRes = rpnDataService.directTo(currentInput: currentInput, title: val)
        
        presenter.presentResult(value: processedRes.0, expression: processedRes.1)
    }
    
    func didChangedAppOrientation(to orientation: AppOrientation) {
        presenter.changePosition(to: orientation)
    }
    
    func firstViewDidLoad() {
        presenter.setStackView()
    }
    
}


 
