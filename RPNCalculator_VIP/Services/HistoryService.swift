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
    //func deleteItem(indexPath: IndexPath)
}

final class HistoryService: HistoryServiceProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchHistory() -> [(String, String)] {
        print("History fetched")
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
        print("History Saved")
        let historyEntry = CalculationHistoryEntity(context: context)
        historyEntry.expression = expression
        historyEntry.result = result
        
        do {
            try context.save()
        } catch {
            print("Failed to save history: \(error.localizedDescription)")
        }
    }
       
    
//    func deleteItem(savedData: [(String,String)], indexPath: IndexPath) {
//        let objectToDelete = savedData[indexPath.row]
//        
//        context.delete(objectToDelete) // Delete from Core Data
//        savedData.remove(at: indexPath.row) // Remove from array
//        
//        do {
//            try context.save() // Save changes
//            tableView.deleteRows(at: [indexPath], with: .fade) // Remove row with animation
//        } catch {
//            print("Failed to delete: \(error)")
//        }
//    }
    
    
}
