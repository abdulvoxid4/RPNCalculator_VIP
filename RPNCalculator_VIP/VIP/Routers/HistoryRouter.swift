//
//  HistoryRouter.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 22/03/25.
//

import UIKit

class HistoryRouter {
    weak var historyViewController: HistoryViewController?
    
    func dismissHistory() {
        historyViewController?.dismiss(animated: true)
    }
}
