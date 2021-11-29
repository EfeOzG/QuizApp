//
//  drillDownViewController.swift
//  QuizApp
//
//  Created by Efe Ozcivelek on 11/17/21.
//

import UIKit

class drillDownViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var displayMessage: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var submitButtonOutlet: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextField.delegate = self
        answerTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let qaIndex = FQsViewController.GlobalVariable.indexNum
        
        if !(FIBViewController.GlobalVariable.fibQuestions.isEmpty) {
            questionTextField.text = FIBViewController.GlobalVariable.fibQuestions[qaIndex]
            answerTextField.text = FIBViewController.GlobalVariable.fibAnswers[qaIndex]
            dateCreated.text = FIBViewController.GlobalVariable.fibQuestionDate[qaIndex]
            displayMessage.text = ""
            questionTextField.textColor = .darkGray
            answerTextField.textColor = .darkGray
            submitButtonOutlet.isEnabled = true
        } else {
            questionTextField.isEnabled = true
            answerTextField.isEnabled = true
            dateCreated.text = ""
            displayMessage.text = ""
        }
    }
    @IBAction func drawButton(_ sender: Any) {
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTime: String = formatter.string(from: Date())
        
        if (questionTextField.text != "" && answerTextField.text != "") {
            if let ans = Int(answerTextField.text!) {
                FIBViewController.GlobalVariable.fibQuestions.append(questionTextField.text!)
                FIBViewController.GlobalVariable.fibAnswers.append(String(ans))
                FIBViewController.GlobalVariable.fibQuestionDate.append(dateTime)
                FIBViewController.GlobalVariable.fibImages.append("nil")

                displayMessage.text = "Success"
                displayMessage.textColor = .darkGray
                dateCreated.text = dateTime
                submitButtonOutlet.isEnabled = false
            } else {
                displayMessage.text = "Enter only integer values"
                displayMessage.textColor = .darkGray
            }
        } else if (questionTextField.text == "" && answerTextField.text != "") {
            displayMessage.text = "Please enter a question"
            displayMessage.textColor = .darkGray
            dateCreated.text = ""
        } else if (answerTextField.text == "" && questionTextField.text != "") {
            displayMessage.text = "Please enter an answer"
            displayMessage.textColor = .darkGray
            dateCreated.text = ""
        } else {
            displayMessage.text = "Please enter question and answer"
            displayMessage.textColor = .darkGray
            dateCreated.text = ""
        }
    }
    @IBAction func qDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func aDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        questionTextField.resignFirstResponder()
        answerTextField.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
//        myImageView.image = image
//        FIBViewController.GlobalVariable.fibImages.append("nil")
//        FIBViewController.GlobalVariable.fibImages[FQsViewController.GlobalVariable.indexNum] = "image.jpeg"
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension drillDownViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == questionTextField) {
            questionTextField.text = ""
        } else if (textField == answerTextField) {
            answerTextField.text = ""
        }
    }
}

