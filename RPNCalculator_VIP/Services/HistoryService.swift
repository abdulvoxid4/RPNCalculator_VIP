//
//  HistoryService.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 24/03/25.
//

import UIKit
import CoreData

protocol HistoryServiceProtocol {
    func saveHistory(result: String, expression: String)
    func fetchHistory() -> [(String, String)]
}

final class HistoryService: HistoryServiceProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchHistory() -> [(String, String)] {
        let request: NSFetchRequest<CalculationHistoryEntity> = CalculationHistoryEntity.fetchRequest()
        
        do {
            let history = try context.fetch(request)
            let formattedHistory = history.map { ($0.expression ?? "", $0.result ?? "") }
            return formattedHistory
        } catch {
            print("Failed to fetch history: \(error.localizedDescription)")
        }
        
        return []
    }
    
    func saveHistory(result: String, expression: String) {
        let historyEntry = CalculationHistoryEntity(context: context)
        historyEntry.expression = expression
        historyEntry.result = result
        
        do {
            try context.save()
        } catch {
            print("Failed to save history: \(error.localizedDescription)")
        }
    }
    
}
