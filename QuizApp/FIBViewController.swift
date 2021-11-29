//
//  FIBViewController.swift
//  QuizApp
//
//  Created by Efe Ozcivelek on 11/14/21.
//

import UIKit

class FIBViewController: UIViewController {
    
    struct GlobalVariable {
        static var fibQuestions: [String] = []
        static var fibAnswers: [String] = []
        static var fibQuestionDate: [String] = []
        static var fibImages: [String] = []
    }
    
    var currentFibQuestionIndex: Int = 0
    
    @IBOutlet var fibQuestionLabel: UILabel!
    @IBOutlet var fibResponseLabel: UILabel!
    @IBOutlet weak var fibSubmitButton: UIButton!
    @IBOutlet weak var fibNextQuestionButton: UIButton!
    @IBOutlet weak var answerField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fibNextQuestionButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !(GlobalVariable.fibQuestions.isEmpty) {
            fibQuestionLabel.text = GlobalVariable.fibQuestions[currentFibQuestionIndex]
            if (currentFibQuestionIndex == 0) {
                fibSubmitButton.isEnabled = true
            }
            answerField.isEnabled = true
        } else {
            fibSubmitButton.isEnabled = false
            answerField.isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        answerField.resignFirstResponder()
    }
    
    @IBAction func fibSubmit(_ sender: Any) {
        if answerField.text == GlobalVariable.fibAnswers[currentFibQuestionIndex] {
            fibResponseLabel.text = "CORRECT"
            fibResponseLabel.textColor = UIColor.green
            fibSubmitButton.isEnabled = false
            ScoreViewController.GlobalVariable.userScore += 10
            ScoreViewController.GlobalVariable.statusColor += 1
        } else {
            fibResponseLabel.text = "INCORRECT"
            fibResponseLabel.textColor = UIColor.red
            fibSubmitButton.isEnabled = false
            ScoreViewController.GlobalVariable.statusColor -= 1
        }
        fibNextQuestionButton.isEnabled = true
    }
    
    @IBAction func showNextFibQuestion(_ sender: UIButton) {
        fibResponseLabel.text = ""
        fibSubmitButton.isEnabled = true
        currentFibQuestionIndex += 1
        if currentFibQuestionIndex >= GlobalVariable.fibQuestions.count {
            fibQuestionLabel.text = ""
            fibNextQuestionButton.isEnabled = false
            fibSubmitButton.isEnabled = false
            fibNextQuestionButton.isEnabled = false
            answerField.text = "-Completed-"
            answerField.isEnabled = false
            return
        }
        let question: String = GlobalVariable.fibQuestions[currentFibQuestionIndex]
        fibQuestionLabel.text = question
        answerField.text = ""
        fibNextQuestionButton.isEnabled = false
    }
}

extension FIBViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
