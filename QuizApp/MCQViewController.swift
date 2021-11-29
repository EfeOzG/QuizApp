//
//  MCQViewController.swift
//  QuizApp
//
//  Created by Efe Ozcivelek on 11/14/21.
//

import UIKit

class MCQViewController: UIViewController {
    
    var currentMcqQuestionIndex: Int = 0
    var mcqAnswer: String = ""
    
    struct GlobalVariable {
        static var mcqQuestions: [String] = [
            "What is the capital of Turkey?",
            "Most populous animal on earth",
            "US independence date"]
        static var mcqAnswers: [String] = ["Ankara", "Human", "July 4, 1776"]
        
        static var mcqAnswerChoices: [[String]] = [
            ["Istanbul", "Ankara", "Izmir"],
            ["Dog", "Cow", "Human"],
            ["July 4, 1776", "January 1, 1879", "December 24, 1952"]
            ]
        static var mcqQuestionDate: [String] = [
            "2021-11-17 21:07:18",
            "2021-11-17 21:07:18",
            "2021-11-17 21:07:18",
            "2021-11-17 21:07:18",
            "2021-11-17 21:07:18",
            "2021-11-17 21:07:18"
        ]
    }
    
    
    @IBOutlet var mcqQuestionLabel: UILabel!
    @IBOutlet weak var mcqPickerView: UIPickerView!
    @IBOutlet weak var mcqResponseLabel: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mcqPickerView.dataSource = self
        mcqPickerView.delegate = self
        nextQuestionButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (currentMcqQuestionIndex < GlobalVariable.mcqQuestions.count) {
            mcqQuestionLabel.text = GlobalVariable.mcqQuestions[currentMcqQuestionIndex]
        }
    }
    
    @IBAction func showNextMcQuestion(_ sender: UIButton) {
        currentMcqQuestionIndex += 1
        if currentMcqQuestionIndex >= GlobalVariable.mcqQuestions.count {
            mcqQuestionLabel.text = "-Completed-"
            nextQuestionButton.isEnabled = false
            mcqResponseLabel.text = ""
            return
        }
        let question: String = GlobalVariable.mcqQuestions[currentMcqQuestionIndex]
        mcqQuestionLabel.text = question
        mcqResponseLabel.text = ""
        viewDidLoad()
    }
}

extension MCQViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.isHidden = false;
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalVariable.mcqAnswerChoices[currentMcqQuestionIndex].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (GlobalVariable.mcqAnswerChoices[currentMcqQuestionIndex][row] == GlobalVariable.mcqAnswers[currentMcqQuestionIndex]) {
            mcqResponseLabel.text = "CORRECT"
            mcqResponseLabel.textColor = UIColor.green
            pickerView.isHidden = true;
            ScoreViewController.GlobalVariable.userScore += 10
            ScoreViewController.GlobalVariable.statusColor += 1
            nextQuestionButton.isEnabled = true
        } else {
            mcqResponseLabel.text = "INCORRECT"
            mcqResponseLabel.textColor = UIColor.red
            pickerView.isHidden = true;
            ScoreViewController.GlobalVariable.statusColor -= 1
            nextQuestionButton.isEnabled = true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GlobalVariable.mcqAnswerChoices[currentMcqQuestionIndex][row]
    }
}

