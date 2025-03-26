//
//  Interactor.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import UIKit
import CoreData

protocol CalculatorInteractorProtocol {
    func processResult(value: CalculatorButtonsEnum, currentInput: String)
    func viewDidLoad()
    func orentationDidChanged()
}


final class CalculatorInteractor: CalculatorInteractorProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Dependencies
    let rpnDataService = RPNDataService()
    let historyService = HistoryService()
    
    var presenter: CalculatorPresenterProtocol
    
    // MARK: - Init
    init(presenter: CalculatorPresenterProtocol) {
        self.presenter = presenter
    }
    
    func processResult(value: CalculatorButtonsEnum, currentInput: String) {
        
        
        let processedRes = rpnDataService.directTo(currentInput: currentInput, title: value)
        
        
        if value == .equal, let expression = processedRes.1,
           expression.rangeOfCharacter(from: CharacterSet(charactersIn: "+-÷×")) != nil
        {
            historyService.saveHistory(result: processedRes.0, expression: expression)
        }
        
        let expressionToPass = processedRes.1?
            .rangeOfCharacter(from: CharacterSet(charactersIn: "+-÷×")) != nil ? processedRes.1 : nil
        presenter.presentResult(value: processedRes.0, expression: expressionToPass)
        
    }
    
    // When App launched for the first time
    func viewDidLoad() {
        presenter.presentCalculatorButtons(shouldRemake: false)
    }
    
    // When orientation is changed
    func orentationDidChanged() {
        presenter.presentCalculatorButtons(shouldRemake: true)
    }
    
}



