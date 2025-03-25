//
//  HistoryAssembly.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 24/03/25.
//

import Foundation


protocol HistoryAssemblyProtocol {
    
    func giveHistoryViewController() -> HistoryViewController
    
}


final class HistoryAssembly: HistoryAssemblyProtocol {
   
    
    func giveHistoryViewController() -> HistoryViewController {
        
        let presenter = HistoryPresenter() // History
        
        let interactor = HistoryInteractor(presenter: presenter)
        
        let historyRouter = HistoryRouter()
        
        let historyView = HistoryViewController(interactor: interactor, router: historyRouter)
        
        presenter.historyView = historyView
        
        historyView.router = historyRouter
        
        historyRouter.historyViewController = historyView
        
        return historyView
    }

    
}
