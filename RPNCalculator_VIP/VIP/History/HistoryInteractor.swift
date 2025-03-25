//
//  HistoryInteractor.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 23/03/25.
//

import UIKit
import CoreData

protocol HistoryInteractorProtocol {
    func didFetchHistory()
    
}

final class HistoryInteractor: HistoryInteractorProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Dependencies
    let historyService = HistoryService()
    
    var presenter: HistoryPresenterProtocol
    
    // MARK: - Init
    init(presenter: HistoryPresenterProtocol) {
        self.presenter = presenter
    }
    
    func didFetchHistory() {
       let fetchedData = historyService.fetchHistory()
        presenter.didFetchHistoryData(fetchedData)
    }
    
}
