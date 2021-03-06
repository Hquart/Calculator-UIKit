//
//  ViewController.swift
//  CountOnMe
//
//  Created by Naji Achkar on 27/12/2019.
//  Copyright © 2019 Naji Achkar. All rights reserved.
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let calculator = Calculator()
    // MARK: - IBOutlets
    @IBOutlet weak var textView: UILabel!
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
        textView.text = "0"
    }
    
    // MARK: - IBActions
    @IBAction func resetButton(_ sender: UIButton) {
        calculator.reset()
    }
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberButton = sender.title(for: .normal) else { return }
        calculator.numberButton(number: numberButton)
    }
    @IBAction func tappedOperandButton(_ sender: UIButton) {
        guard let operandButton = sender.title(for: .normal) else {  return }
        calculator.operandButton(operand: operandButton)
    }
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.equalButton()
    }
}
// MARK: - Extension
extension ViewController: DisplayDelegate {
    func updateDisplay(text: String) {
        textView.text = text
    }
    func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message:
            "Veuillez entrer une expression correcte !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}

