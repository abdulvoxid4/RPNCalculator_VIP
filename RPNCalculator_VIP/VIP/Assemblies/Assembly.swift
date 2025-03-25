//
//  Assembly.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import Foundation


protocol AssemblyProtocol {
    
    func giveViewController() -> ViewController
    
}


final class Assembly: AssemblyProtocol {
   
    
    func giveViewController() -> ViewController {
        
        let presenter = CalculatorPresenter()
        
        let interactor = CalculatorInteractor(presenter: presenter)
        
        let calculatorRouter = CalculatorRouter()
        
        let view = ViewController(interactor: interactor, router: calculatorRouter)
        
        presenter.view = view
        
        view.router = calculatorRouter
        
        calculatorRouter.calculatorViewController = view
        
        return view
    }

    
}
