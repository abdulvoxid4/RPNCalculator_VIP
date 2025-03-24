//
//  HistoryPresenter.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 24/03/25.
//


protocol HistoryPresenterProtocol {
   func didFetchHistoryData(_ history: [(expression: String, result: String)])
}

final class HistoryPresenter: HistoryPresenterProtocol {
   
    weak var historyView: HistoryViewController?
    
    func didFetchHistoryData(_ history: [(expression: String, result: String)]) {
        historyView?.updateHistory(history)
    }
}
