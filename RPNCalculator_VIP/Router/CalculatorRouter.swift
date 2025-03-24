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
           historyVC.modalPresentationStyle = .pageSheet
           
           if let sheet = historyVC.sheetPresentationController {
               sheet.detents = [.medium(), .large()]
               sheet.prefersGrabberVisible = true   // Shows grabber handle
           }
        print("Inside CalculatorRouter")
        calculatorViewController?.present(historyVC, animated: true)
       }
}
