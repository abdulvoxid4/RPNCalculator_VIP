//
//  Interactor.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import UIKit
import CoreData

protocol CalculatorInteractorProtocol {
    func processResult(val: CalculatorButtonsEnum, currentInput: String)
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

    func processResult(val: CalculatorButtonsEnum, currentInput: String) {
        
        
       let processedRes = rpnDataService.directTo(currentInput: currentInput, title: val)
        
        
        if val == .equal {
            historyService.saveHistory(result: processedRes.0, expression: processedRes.1 ?? "Error")
        }
        
        presenter.presentResult(value: processedRes.0, expression: processedRes.1)
    }
    
    func viewDidLoad() {
        presenter.makeCalculatorButtons(sholdRemake: false)
    }
    
    func orentationDidChanged() {
        presenter.makeCalculatorButtons(sholdRemake: true)
    }
}


 
