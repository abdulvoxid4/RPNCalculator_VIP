//
//  CalculatorRouter.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 22/03/25.
//

import UIKit

class CalculatorRouter {
    weak var calculatorViewController: ViewController?
    
    func navigateToHistory() {
        let historyVC = HistoryAssembly().giveHistoryViewController()
        let navController = UINavigationController(rootViewController: historyVC)
        navController.modalPresentationStyle = .pageSheet
           
           if let sheet = navController.sheetPresentationController {
               sheet.detents = [.medium(), .large()]
               sheet.prefersGrabberVisible = true   // Shows grabber handle
           }
        print("Inside CalculatorRouter")
        calculatorViewController?.present(navController, animated: true)
       }
}
