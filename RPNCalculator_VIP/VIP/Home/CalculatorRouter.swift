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
           
           if let bottomSheet = navController.sheetPresentationController {
               bottomSheet.detents = [.medium(), .large()]
               bottomSheet.prefersGrabberVisible = true
           }
        calculatorViewController?.present(navController, animated: true)
       }
}
