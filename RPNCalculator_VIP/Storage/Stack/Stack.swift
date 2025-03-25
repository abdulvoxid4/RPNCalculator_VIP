//
//  Stack.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 25/03/25.
//

import UIKit

struct Stack<T> {
    private var elements: [T] = []
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    var top: T? {
        return elements.last
    }
    
    mutating func push(_ element: T) {
        elements.append(element)
    }
    
    mutating func pop() -> T? {
        return elements.popLast()
    }
    
    func peek() -> T? {
        return elements.last
    }
    
    func allElements() -> [T] {
        return elements
    }
}

