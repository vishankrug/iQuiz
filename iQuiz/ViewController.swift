//
//  ViewController.swift
//  iQuiz
//
//  Created by Vishank Rughwani on 5/6/21.
//

import UIKit

class SubjectsSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicStyle", for: indexPath)
        cell.textLabel?.text = subject[indexPath.row]
        cell.detailTextLabel?.text = subjectDescription[indexPath.row]
        return cell
    }
    
    let subject = ["Mathematics", "Marvel Super Heroes", "Science"]
    let subjectDescription = ["Take a Math test!", "Think you know your Marvel Super Heroes?", "Want to be a Scientist?"]
}

class Topic{
    var title : String
    var description : String
    //var image :
    var questions : [Question]
    
    init(title t: String, description d: String, questions q: [Question]){
        title = t
        description = d
        questions = q
    }
}

class Question {
    var question : String
    var answer1 : String
    var answer2 : String
    var answer3 : String
    var answer4 : String
    var rightAnswer : String
    
    init(question q: String, answer1 a1: String, answer1 a2: String, answer1 a3: String, answer1 a4: String, rightanswer rs: String){
        question = q
        answer1 = a1
        answer2 = a2
        answer3 = a3
        answer4 = a4
        rightAnswer = rs
    }
    
}

class ViewController: UIViewController{
    
    let data = SubjectsSource()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = data
    }
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Alert!", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {_ in }))
        present(alert, animated: true)
    }
    

}

