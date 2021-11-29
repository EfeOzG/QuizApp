//
//  FQsViewController.swift
//  QuizApp
//
//  Created by Efe Ozcivelek on 11/15/21.
//

import UIKit

class FQsViewController: UIViewController {
    
    struct GlobalVariable {
        static var indexNum = 0
    }
    
    @IBOutlet weak var FQsTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    @IBAction func editAction(_ sender: Any) {
        FQsTableView.isEditing = !FQsTableView.isEditing
        
        switch FQsTableView.isEditing {
        case true:
            editButton.title = "Done"
        case false:
            editButton.title = "Edit"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        FQsTableView.delegate = self
        FQsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.FQsTableView.reloadData()
        GlobalVariable.indexNum = 0
    }

}

extension FQsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalVariable.indexNum = indexPath.row
        self.performSegue(withIdentifier: "FQsToDrillDown", sender: self)
    }
}

extension FQsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FIBViewController.GlobalVariable.fibQuestions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "fibCells")
        cell.textLabel?.text = FIBViewController.GlobalVariable.fibQuestions[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        cell.detailTextLabel?.text = FIBViewController.GlobalVariable.fibAnswers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let qItem = FIBViewController.GlobalVariable.fibQuestions[sourceIndexPath.row]
        let aItem = FIBViewController.GlobalVariable.fibAnswers[sourceIndexPath.row]
        let dItem = FIBViewController.GlobalVariable.fibQuestionDate[sourceIndexPath.row]
        let iItem = FIBViewController.GlobalVariable.fibImages[sourceIndexPath.row]
        FIBViewController.GlobalVariable.fibQuestions.remove(at: sourceIndexPath.row)
        FIBViewController.GlobalVariable.fibQuestions.insert(qItem, at: destinationIndexPath.row)
        FIBViewController.GlobalVariable.fibAnswers.remove(at: sourceIndexPath.row)
        FIBViewController.GlobalVariable.fibAnswers.insert(aItem, at: destinationIndexPath.row)
        FIBViewController.GlobalVariable.fibQuestionDate.remove(at: sourceIndexPath.row)
        FIBViewController.GlobalVariable.fibQuestionDate.insert(dItem, at: destinationIndexPath.row)
        FIBViewController.GlobalVariable.fibImages.remove(at: sourceIndexPath.row)
        FIBViewController.GlobalVariable.fibImages.insert(iItem, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FQsTableView.beginUpdates()
            FIBViewController.GlobalVariable.fibQuestions.remove(at: indexPath.row)
            FIBViewController.GlobalVariable.fibAnswers.remove(at: indexPath.row)
            FIBViewController.GlobalVariable.fibQuestionDate.remove(at: indexPath.row)
            FIBViewController.GlobalVariable.fibImages.remove(at: indexPath.row)
            FQsTableView.deleteRows(at: [indexPath], with: .fade)
            FQsTableView.endUpdates()
        }
    }
}
