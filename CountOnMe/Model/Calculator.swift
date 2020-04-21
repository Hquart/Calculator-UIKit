//
//  File.swift
//  CountOnMe
//
//  Created by Naji Achkar on 28/12/2019.
//  Copyright © 2019 Naji Achkar. All rights reserved.
//
import Foundation
// Using Delegate Protocol to send display data to the View Controller:
protocol DisplayDelegate: class {
    func updateDisplay(text: String)
    func presentAlert()
}
final class Calculator {
    
    // MARK: - Properties
    
    weak var delegate: DisplayDelegate?
    // Array storing elements of the math expression:
    var elements: [String] = []
    // Display sent to View Controller by the delegate:
    var display: String {
        return elements.joined()
    }
    
    // MARK: - Computed variables
    
    // This variable checks all possible errors in the expression preventing from producing a result
    var expressionIsCorrect: Bool {
        return elements.count >= 3 && expressionHasOperand && !lastElementIsOperand
            && !(display.contains("/0"))
    }
    var lastElementIsOperand: Bool {
        guard let lastElement = elements.last else { return false }
        return lastElement == "+" || lastElement == "-" || lastElement == "*" || lastElement == "/"
    }
    var lastElementIsNumber: Bool {
        guard let lastElement = display.last else { return false }
        return lastElement.isNumber == true
    }
    
    var expressionHasOperand: Bool {
        return elements.contains("+") || elements.contains("-") || elements.contains("*")
            || elements.contains("/")
    }
    var canAddOperator: Bool {
        return elements.count != 0 && !lastElementIsOperand
    }
    var expressionHasResult: Bool {
        return elements.contains("=")
    }
    // MARK: - Methods
    
    // Method linked to Reset Button (AC)
    func reset() {
        elements.removeAll()
        delegate?.updateDisplay(text: "0")
    }
    // This func will solve priority operations ("x" and "/") in the expression
    func managePriorities() -> [String] {
        var operationsToReduce = elements
        while operationsToReduce.contains("*") || operationsToReduce.contains("/") {
            if let index = operationsToReduce.firstIndex(where: { $0 == "*" || $0 == "/" })  {
                let operand = operationsToReduce[index]
                let result: Double
                if let left = Double(operationsToReduce[index - 1]) {
                    if let right = Double(operationsToReduce[index + 1]) {
                        if operand == "*" {
                            result = left * right
                        } else {
                            result = left / right
                        }
                        //Replacing elements of the multiplication with its result:
                        operationsToReduce.remove(at: index + 1)
                        operationsToReduce.remove(at: index)
                        operationsToReduce.remove(at: index - 1)
                        operationsToReduce.insert(formatResult(result), at: index - 1)
                    }
                }
            }
        }
        return operationsToReduce
    }
    //This is the main algorithm which will produce the result from the expression:
    func performCalcul() {
        var expression = managePriorities()
        // Iterate over operations while an operand still here:
        while expression.count > 1 {
            guard let left = Double(expression[0]) else { return }
            guard let right = Double(expression[2]) else { return }
            let operand = expression[1]
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: return
            }
            expression = Array(expression.dropFirst(3))
            expression.insert(formatResult(result), at: 0)
        }
        //Add result to elements to update display
        guard let finalResult = expression.first else { return }
        elements.append("=")
        elements.append("\(finalResult)")
    }
    //This func will call the delegate method to update display in the View Controller:
    func notifyDisplay() {
        delegate?.updateDisplay(text: display)
    }
    //  This func will join numbers in the expression and will be used in next func: numberButton()
    func joiningNumbers(next: String) {
        guard let lastElement = elements.last else { return }
        let newElement = lastElement + next
        elements.removeLast()
        elements.append(newElement)
    }
    func numberButton(number: String) {
        if expressionHasResult  { // If there is already a result, tapping a number will start a new expression:
            elements.removeAll()
            elements.append(number)
        } else if lastElementIsNumber {
            joiningNumbers(next: number)
        } else {
            elements.append(number)
        }
        notifyDisplay()
    }
    func operandButton(operand: String) {
        if expressionHasResult { // if there is already a result, we will start a new expression with it:
            if let result = elements.last {
                elements.removeAll()
                elements.append("\(result)")
                elements.append("\(operand)")
                notifyDisplay()
            }
        } else {
            if canAddOperator {
                elements.append("\(operand)")
                notifyDisplay()
            }
        }
    }
    private func formatResult(_ result: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        guard let formatedResult = formatter.string(from: NSNumber(value: result)) else { return String() }
        return formatedResult
    }
    func equalButton() {
        // First check if the expression is correct and can produce a result otherwise, send an Alert
        guard expressionIsCorrect else {
            delegate?.presentAlert()
            return
        }
        // Then check if there is already a result before performing calcul, otherwise pressing equal does nothing
        if !expressionHasResult  {
            performCalcul()
            notifyDisplay()
            return
        }
    }
}






