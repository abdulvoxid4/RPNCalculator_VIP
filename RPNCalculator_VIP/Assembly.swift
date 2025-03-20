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
        
        let view = ViewController(interactor: interactor)
        
        presenter.view = view
        
        
        return view
    }

    
}
