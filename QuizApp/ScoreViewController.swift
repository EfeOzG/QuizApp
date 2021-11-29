//
//  ScoreViewController.swift
//  QuizApp
//
//  Created by Efe Ozcivelek on 11/14/21.
//

import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    struct GlobalVariable {
        static var userScore = 0
        static var statusColor = 0
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let numOfCorrect = GlobalVariable.userScore/10
        scoreLabel.text = String(GlobalVariable.userScore)
        statusLabel.text = String(numOfCorrect) + "/" + String(FIBViewController.GlobalVariable.fibQuestions.count + MCQViewController.GlobalVariable.mcqQuestions.count) + " Correct"
        if (GlobalVariable.statusColor > 0) {
            self.view.backgroundColor = UIColor(red: 153/255.0, green: 255/255.0, blue: 167/255.0, alpha: 1.0)
            
        } else if (GlobalVariable.statusColor < 0) {
            self.view.backgroundColor = UIColor(red: 255/255.0, green: 145/255.0, blue: 145/255.0, alpha: 1.0)
        } else {
            self.view.backgroundColor = UIColor.lightGray
        }
    }
}
