//
//  RPNDataService.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

protocol RPNDataServiceProtocol {
    
    func directTo(currentInput: String, title: CalculatorButtonsEnum) -> (String,String?)
    
}

final class RPNDataService: RPNDataServiceProtocol {
    
    typealias CB = CalculatorButtonsEnum
    var isNewInput = true
    
    
    func directTo(currentInput: String, title: CalculatorButtonsEnum) -> (String, String?) {
        if title == .equal {
            isNewInput = false
            let better = currentInput.removeUntilLastNumber ?? currentInput
            
            if let postfixInput = infinixToPostfix(inputValue: better) {
                if let result = (calculate(postfixInput)) {
                    return (formatResult(result: result), better)
                }
            }
            
        } else {
            return (buttonPressed(currentInput: currentInput, title: title), nil)
        }
        return ("Error", "")
    }
    
    private func buttonPressed(currentInput: String, title: CB) -> String {
        
        var newCurrentInput = currentInput
        let operators: Set<Character> = [CB.plus.char, CB.minus.char, CB.multiplyX.char, CB.divide.char]
        let operatorsWithBrackets: Set<Character> = [CB.plus.char, CB.minus.char, CB.multiplyX.char, CB.divide.char, CB.open.char, CB.close.char]
        let lastNumber = newCurrentInput.split(whereSeparator: { operators.contains($0) }).last ?? ""
        let lastNumberWithoutBrackets = newCurrentInput.split(whereSeparator: { operatorsWithBrackets.contains($0) }).last ?? ""
        let lastChar = newCurrentInput.last ?? "E"
        
        if newCurrentInput == "Error" {
            newCurrentInput = ""
        }
        
        switch title {
            // Zero case
        case .zero:
            return zeroHandler(
                lastNumber: lastNumber,
                lastChar: lastChar,
                lastNumberWithoutBrackets: lastNumberWithoutBrackets,
                newCurrentInput: newCurrentInput)
            
            // Backspace case
        case .backspace:
            return backspaceHandler(newCurrentInput: newCurrentInput)
            
            // All Clear, AC case
        case .allClear:
            isNewInput = true
            return CB.zero.rawValue
            
            // Dot case
        case .dot:
            return dotHandler(lastNumber: lastNumber,
                              lastChar: lastChar,
                              operators: operators,
                              newCurrentInput: newCurrentInput
            )
            
            // Operators case
        case .plus, .multiplyX, .divide, .minus:
            return operatorsHandler(lastChar: lastChar,
                                    operators: operators,
                                    title: title,
                                    newCurrentInput: newCurrentInput
            )
            
            // Open parenthesis case
        case .open:
            return openParenthesisHandler(newCurrentInput: newCurrentInput)
            
            // Close parenthesis case
        case .close:
            return closeParenthesisHandler(lastChar: lastChar,
                                           operators: operators,
                                           newCurrentInput: newCurrentInput)
            
            // Numbers case
        default:
            return numbersHandler(
                lastNumber: lastNumber,
                lastChar: lastChar,
                title: title,
                operators: operators,
                lastNumberWithoutBrackets: lastNumberWithoutBrackets,
                newCurrentInput: newCurrentInput)
        }
        
    }
    
    // Evaluates and calculates the RPN expression
    private func calculate(_ input: String) -> String? {
        var stack = Stack<Double>()
        let tokens = input.split(separator: " ")
        print("Tokens: \(tokens)")
        
        for token in tokens {
            
            if token == CB.open.rawValue || token == CB.close.rawValue {
                continue
            }
            
            if let number = Double(token) {
                stack.push(number)
            } else {
                guard stack.count >= 2 else { return nil }
                guard let b = stack.pop(), let a = stack.pop() else { return nil } // Safely unwrap
                let result: Double
                switch token {
                case CB.plus.rawValue:
                    result = a + b
                case CB.minus.rawValue:
                    result = a - b
                case CB.multiplyX.rawValue:
                    result = a * b
                case  CB.divide.rawValue:
                    if b != 0 {
                        result = a / b
                    } else {
                        return nil
                    }
                default: return nil
                }
                stack.push(result)
            }
        }
        return  stack.top?.description
    }
    
    // Converts infix expression to postfix (RPN)
    private func infinixToPostfix(inputValue: String) -> String? {
        let precedence: [Character: Int] = [
            CB.plus.char: 1,
            CB.minus.char: 1,
            CB.multiplyX.char: 2,
            CB.divide.char: 2
        ] // Prority of operator
        
        var output = Stack<String>()
        var operators = Stack<Character>()
        var numberBuffer = ""
        
        
        for (index, char) in inputValue.enumerated() {
            if char.isNumber || char == "e" || char == CB.dot.char  {
                numberBuffer.append(char)
            } else {
                if !numberBuffer.isEmpty {
                    output.push(numberBuffer)
                    numberBuffer = ""
                }
                
                if char == CB.minus.char && (index == 0 || inputValue[inputValue.index(inputValue.startIndex, offsetBy: index - 1)] == CB.open.char) {
                    numberBuffer.append(char)
                    
                } else if char == CB.open.char {
                    operators.push(char)
                    
                } else if char == CB.close.char {
                    while let lastOp = operators.peek(), lastOp != CB.open.char {
                        if let popedOperator = operators.pop() {
                            output.push(String(popedOperator))
                        }
                    }
                    _ = operators.pop() // Remove '(' from stack
                    
                } else if precedence[char] != nil {
                    while let lastOp = operators.peek(),
                          let lastPrecedence = precedence[lastOp],
                          let currentPrecedence = precedence[char],
                          lastPrecedence >= currentPrecedence {
                        
                        if let poppedOperator = operators.pop() {
                            output.push(String(poppedOperator))
                        }
                    }
                    operators.push(char)
                }
            }
        }
        
        if !numberBuffer.isEmpty {
            output.push(numberBuffer)
        }
        
        while let poppedOperator = operators.pop() {
            output.push(String(poppedOperator))  // Pushing remaining operators to output
        }
        
        let result = output.allElements().joined(separator: " ")
        print("RPN output: \(result)")
        return result
    }
    
    private func formatResult(result: String) -> String {
        guard let doubleResult = Double(result) else {
            return result
        }
        
        let formatted: String
        
        if doubleResult == doubleResult.rounded(.down) {
            if doubleResult >= Double(Int.min) && doubleResult <= Double(Int.max) {
                formatted = String(Int(doubleResult))
            } else {
                formatted = String(format: "%.5g", doubleResult) // It shows with 5 decimal numbers
            }
        } else {
            formatted = String(format: "%.5g", doubleResult)
        }
        
        return formatted.replacingOccurrences(of: "e-", with: "e").replacingOccurrences(of: "e+", with: "e")
    }
    
    
    
}

extension RPNDataService {
    func zeroHandler(lastNumber: String.SubSequence, lastChar: Character, lastNumberWithoutBrackets: String.SubSequence, newCurrentInput: String) -> String {
        var currentInput = newCurrentInput
        if isNewInput {
            if currentInput == CB.zero.rawValue || (lastNumberWithoutBrackets == CB.zero.rawValue && lastChar == CB.zero.char) {
                return currentInput
            } else if lastChar == CB.close.char {
                currentInput += CB.multiplyX.rawValue + CB.zero.rawValue
            } else {
                currentInput += CB.zero.rawValue
            }
            return currentInput
        } else {
            return CB.zero.rawValue
        }
    }
    
    func numbersHandler(
        lastNumber: String.SubSequence,
        lastChar: Character,
        title: CalculatorButtonsEnum,
        operators: Set<Character>,
        lastNumberWithoutBrackets: String.SubSequence,
        newCurrentInput: String) -> String {
            
            var currentInput = newCurrentInput
            if isNewInput {
                if currentInput == CB.zero.rawValue || lastNumberWithoutBrackets == CB.zero.rawValue{
                    if operators.contains(lastChar) {
                        currentInput += title.rawValue
                    } else {
                        if lastChar != CB.open.char {
                            currentInput.removeLast()
                        }
                        currentInput += title.rawValue
                    }
                } else if lastChar == CB.close.char {
                    
                    currentInput += CB.multiplyX.rawValue + title.rawValue
                } else if lastNumberWithoutBrackets == CB.zero.rawValue && lastChar != CB.dot.char {
                    
                    currentInput.removeLast()
                    currentInput += title.rawValue
                } else {
                    currentInput += title.rawValue
                }
            } else {
                currentInput = ""
                currentInput = title.rawValue
                isNewInput = true
            }
            return currentInput
        }
    
    func dotHandler(lastNumber:String.SubSequence, lastChar: Character, operators: Set<Character>, newCurrentInput: String) -> String {
        isNewInput = true
        var currentInput = newCurrentInput
        if !lastNumber.contains(CB.dot.rawValue) && (currentInput.last?.isNumber ?? false) {
            currentInput += CB.dot.rawValue
        } else if operators.contains(lastChar) || lastChar == CB.open.char {
            currentInput += CB.zero.rawValue + CB.dot.rawValue
        } else if lastChar == CB.close.char {
            currentInput += CB.multiplyX.rawValue + CB.zero.rawValue + CB.dot.rawValue
        }
        
        return currentInput
    }
    
    func operatorsHandler(lastChar: Character, operators: Set<Character>, title: CalculatorButtonsEnum, newCurrentInput: String) -> String {
        isNewInput = true
        var currentInput = newCurrentInput
        let beforeLastChar = String(newCurrentInput.dropLast())
        if lastChar == CB.minus.char && beforeLastChar.last == CB.open.char {
            return currentInput
        }
        
        if operators.contains(String(lastChar)) || lastChar == CB.dot.char ||
            (currentInput == CB.zero.rawValue && title.rawValue == CB.minus.rawValue) {
            currentInput.removeLast()
        } else if lastChar == CB.open.char && title.rawValue != CB.minus.rawValue {
            return currentInput
        }
        currentInput += title.rawValue
        return currentInput
    }
    
    
    
    func openParenthesisHandler(newCurrentInput: String) -> String {
        isNewInput = true
        var currentInput = newCurrentInput
        
        if currentInput == CB.zero.rawValue {
            currentInput = CB.open.rawValue
        } else if let lastChar = currentInput.last {
            if lastChar == CB.dot.char {
                currentInput.removeLast()
                currentInput += CB.multiplyX.rawValue + CB.open.rawValue
            } else if lastChar.isNumber || lastChar == CB.close.char {
                currentInput += CB.multiplyX.rawValue + CB.open.rawValue
            } else {
                currentInput += CB.open.rawValue
            }
        } else {
            currentInput += CB.open.rawValue
        }
        return currentInput
    }
    
    func closeParenthesisHandler(lastChar: Character, operators: Set<Character>, newCurrentInput: String) -> String{
        isNewInput = true
        var currentInput = newCurrentInput
        let openCount = currentInput.filter { $0 == CB.open.char }.count
        let closeCount = currentInput.filter { $0 == CB.close.char }.count
        
        if openCount > closeCount, lastChar.isNumber || lastChar == CB.close.char {
            if operators.contains(currentInput.last ?? "A") {
                currentInput.removeLast()
                currentInput += CB.close.rawValue
            } else  {
                currentInput += CB.close.rawValue
            }
        }
        return currentInput
    }
    
    func backspaceHandler(newCurrentInput: String) -> String {
        isNewInput = true
        var currentInput = newCurrentInput
        
        if currentInput.count == 1 {
            currentInput = CB.zero.rawValue
        } else {
            currentInput.removeLast()
        }
        return currentInput
    }
    
}
