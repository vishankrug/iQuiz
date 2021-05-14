//
//  ViewController.swift
//  iQuiz
//
//  Created by Vishank Rughwani on 5/6/21.
//

import UIKit

let mathematics = Topic(title: "Mathematics", description: "Take a Math test!", questions: [
                            Question(question: "2+2", answers: [
                                        Answer(ans: "1", correct: false),
                                        Answer(ans: "2", correct: false),
                                        Answer(ans: "3", correct: false),
                                        Answer(ans: "4", correct: true)]),
                            Question(question: "2+5", answers: [
                                        Answer(ans: "1", correct: false),
                                        Answer(ans: "2", correct: false),
                                        Answer(ans: "7", correct: true),
                                        Answer(ans: "4", correct: false)]),
                            Question(question: "2+10", answers: [
                                        Answer(ans: "1", correct: false),
                                        Answer(ans: "12", correct: true),
                                        Answer(ans: "3", correct: false),
                                        Answer(ans: "4", correct: false)])])

let marvel_super_hereos = Topic(title: "Marvel Super Heroes", description: "Think you know your Marvel Super Heroes?", questions: [
                            Question(question: "Who is spider-man?", answers: [
                                        Answer(ans: "Peter Parker", correct: true),
                                        Answer(ans: "Bruce Wayne", correct: false),
                                        Answer(ans: "Me", correct: false),
                                        Answer(ans: "You", correct: false)]),
                            Question(question: "Who is the best superhero?", answers: [
                                        Answer(ans: "Spiderman", correct: false),
                                        Answer(ans: "Batman", correct: false),
                                        Answer(ans: "Ironman", correct: true),
                                        Answer(ans: "Superman", correct: false)])])

let science = Topic(title: "Science", description: "Want to be a Scientist?", questions: [
                            Question(question: "Animals that eat both plants and meat are called what?", answers: [
                                        Answer(ans: "Omnivores", correct: true),
                                        Answer(ans: "Carnivores", correct: false),
                                        Answer(ans: "Cannibals", correct: false),
                                        Answer(ans: "Me", correct: false)])])

let subject = [mathematics, marvel_super_hereos, science]



class QuestionSource: NSObject, UITableViewDataSource {
    var currentSubject: String
    
    init(subject s: String){
        currentSubject = s
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject[0].questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicStyle", for: indexPath)
        cell.textLabel?.text = subject[0].questions[indexPath.row].question
        return cell
    }
    
}

class Topic{
    var title : String
    var description : String
    var questions : [Question]
    
    init(title t: String, description d: String, questions q: [Question]){
        title = t
        description = d
        questions = q
    }
}

class Question {
    var question : String
    var answers : [Answer]
    
    init(question q: String, answers a1: [Answer]){
        question = q
        answers = a1
    }
}

class Answer {
    let ans: String
    let correct: Bool
    init(ans a: String, correct c: Bool){
        ans = a
        correct = c
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject.count
    }
    
    var currentSubject = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicStyle", for: indexPath)
        cell.textLabel?.text = subject[indexPath.row].title
        cell.detailTextLabel?.text = subject[indexPath.row].description
        return cell
    }
    
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Alert!", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {_ in }))
        present(alert, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        currentSubject = indexPath.row
        performSegue(withIdentifier: "quizSelector", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quizSelector" {
            let controller = segue.destination as! QuestionViewController
            controller.currentQuestions = subject[currentSubject].questions
        }
    }

}

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var questionTable: UITableView!
    var currentQuestions = [Question]()
    var currentQuestionInt = 0;
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestions[currentQuestionInt].answers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        cell.textLabel?.text = currentQuestions[currentQuestionInt].answers[indexPath.row].ans
            //currentQuestions[indexPath.row].answers[indexPath.row].ans
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTable.dataSource = self
        questionTable.delegate = self
        questionTable.tableFooterView = UIView()
        questionText.text = currentQuestions[0].question
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        currentQuestionInt+=1
        //currentAnswer = indexPath.row
        performSegue(withIdentifier: "answerSelector", sender: cell)
    }
    
}

class AnswerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

