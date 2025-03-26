//
//  StringExt.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 21/03/25.
//

extension String {
    
    typealias CB = CalculatorButtonsEnum
    
    var removeUntilLastNumber: String? {
        
        var string = self
        let opearators =  [
            CB.plus.char,
            CB.minus.char,
            CB.multiplyX.char,
            CB.divide.char,
            CB.open.char
        ]
        
        while let lastChar = string.last, opearators.contains(lastChar) {
            if string.isEmpty {return nil}
            string.removeLast()
        }
        return string
    }
    
}
