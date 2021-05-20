//
//  ViewController.swift
//  iQuiz
//
//  Created by Vishank Rughwani on 5/6/21.
//

import UIKit


//let mathematics = Topic(title: "Mathematics", description: "Take a Math test!", questions: [
//                            Question(question: "2+2", answers: [
//                                        Answer(ans: "1", correct: false),
//                                        Answer(ans: "2", correct: false),
//                                        Answer(ans: "3", correct: false),
//                                        Answer(ans: "4", correct: true)]),
//                            Question(question: "2+5", answers: [
//                                        Answer(ans: "1", correct: false),
//                                        Answer(ans: "2", correct: false),
//                                        Answer(ans: "7", correct: true),
//                                        Answer(ans: "4", correct: false)]),
//                            Question(question: "2+10", answers: [
//                                        Answer(ans: "1", correct: false),
//                                        Answer(ans: "12", correct: true),
//                                        Answer(ans: "3", correct: false),
//                                        Answer(ans: "4", correct: false)])])
//
//let marvel_super_hereos = Topic(title: "Marvel Super Heroes", description: "Think you know your Marvel Super Heroes?", questions: [
//                            Question(question: "Who is spider-man?", answers: [
//                                        Answer(ans: "Peter Parker", correct: true),
//                                        Answer(ans: "Bruce Wayne", correct: false),
//                                        Answer(ans: "Me", correct: false),
//                                        Answer(ans: "You", correct: false)]),
//                            Question(question: "Who is the best superhero?", answers: [
//                                        Answer(ans: "Spiderman", correct: false),
//                                        Answer(ans: "Batman", correct: false),
//                                        Answer(ans: "Ironman", correct: true),
//                                        Answer(ans: "Superman", correct: false)])])
//
//let science = Topic(title: "Science", description: "Want to be a Scientist?", questions: [
//                            Question(question: "Animals that eat both plants and meat are called what?", answers: [
//                                        Answer(ans: "Omnivores", correct: true),
//                                        Answer(ans: "Carnivores", correct: false),
//                                        Answer(ans: "Cannibals", correct: false),
//                                        Answer(ans: "Me", correct: false)])])

var subject = [Topic]()
var totalCorrect = 0


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
    var desc : String
    var questions : [Question]
    
    init(title t: String, description d: String, questions q: [Question]){
        title = t
        desc = d
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

class JSONSource {

}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var jsonArray: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let url = URL(string: "http://tednewardsandbox.site44.com/questions.json")
        
//        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
//            guard let data = data, error == nil else{
//                print("sm went wrong")
//                return
//            }
//
//            var result:
//
//        })
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data else {return}
                do{
                    let questions = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    for topics in (questions as! Array<Any>){
                        var j = 0
                        var questionsArray = Question(question: "", answers: [Answer(ans: "", correct: false)])
                        let titles = (topics as! Dictionary<String, Any>)["title"]!
                        let desc = (topics as! Dictionary<String, Any>)["desc"]!
                        let ques = (topics as! Dictionary<String, Any>)["questions"]!
                        for questionDetails in (ques as! Array<Any>){
                            var answersArray = [Answer]()
                            let questionText = (questionDetails as! Dictionary<String, Any>)["text"]!
                            let questionAnswer = (questionDetails as! Dictionary<String, Any>)["answer"]!
                            let ans = (questionDetails as! Dictionary<String, Any>)["answers"]!
                            var i = 0
                            for question in (ans as! Array<Any>){
                                let a = question
                                var isAnswer = false
                                //print(a as! String)
                                //print(questionAnswer as! String)
                                if(String(i+1) == (questionAnswer as! String)){
                                    isAnswer = true
                                }
                                //let a1 = question
                                answersArray.insert(Answer(ans: a as! String, correct: isAnswer), at: i)
                                i += 1
                            }
                            questionsArray = Question(question: questionText as! String, answers: [
                                                        Answer(ans: answersArray[0].ans, correct: answersArray[0].correct),
                                                        Answer(ans: answersArray[1].ans, correct: answersArray[1].correct),
                                                        Answer(ans: answersArray[2].ans, correct: answersArray[2].correct),
                                                        Answer(ans: answersArray[3].ans, correct: answersArray[3].correct)])
                        }
                        subject.append(Topic(title: titles as! String, description: desc as! String, questions: [
                                                questionsArray]))
                        j += 1
                    }
                }catch {
                    print("error")
                }
            }.resume()
            
        }
        
        Thread.sleep(forTimeInterval: 0.1)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(subject)
        return subject.count
    }
    
    var currentSubject = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicStyle", for: indexPath)
        cell.textLabel?.text = subject[indexPath.row].title
        cell.detailTextLabel?.text = subject[indexPath.row].desc
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
            controller.currentQuestionInt = 0
            controller.subject = currentSubject
        }
    }

}

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var questionTable: UITableView!
    var currentQuestions = [Question]()
    var subject = Int()
    var currentQuestionInt = Int();
    var isAnswerCorrect = false;
    var correctAnswer = ""
    var cell: UITableViewCell?
    
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
        questionText.text = currentQuestions[currentQuestionInt].question
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isAnswerCorrect = currentQuestions[currentQuestionInt].answers[indexPath.row].correct
        
        for i in 0...currentQuestions[currentQuestionInt].answers.count-1{
            if(currentQuestions[currentQuestionInt].answers[i].correct == true){
                correctAnswer = currentQuestions[currentQuestionInt].answers[i].ans
            }
        }
        
        cell = tableView.cellForRow(at: indexPath)
    }
    @IBAction func submitButton(_ sender: Any) {
        if (isAnswerCorrect){
            totalCorrect+=1
        }
        performSegue(withIdentifier: "answerSelector", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "answerSelector" {
            let controller = segue.destination as! AnswerViewController
            controller.subjectInt = subject
            controller.question = currentQuestions[currentQuestionInt].question
            controller.current = currentQuestionInt+1;
            controller.total = currentQuestions.count
            controller.isCorrect = isAnswerCorrect
            controller.correctAns = correctAnswer
        }
    }
    
}

class AnswerViewController: UIViewController {
    var subjectInt = Int()
    var question = String()
    var total = Int()
    var current = Int()
    var isCorrect = Bool()
    var correctAns = String()

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var rightWrongLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question
        answerLabel.text = correctAns
        if(isCorrect){
            rightWrongLabel.text = "Correct!"
        }else{
            rightWrongLabel.text = "Wrong!"
        }
        if(current == total){
            submitButton.setTitle("Finish", for: .normal)
        }else{
            submitButton.setTitle("Next Question", for: .normal)
        }
    }
    @IBAction func buttonPress(_ sender: Any) {
        if(current == total){
            performSegue(withIdentifier: "finishSelector", sender: self)
        }else{
            performSegue(withIdentifier: "nextQuestion", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextQuestion" {
            let controller = segue.destination as! QuestionViewController
            controller.currentQuestions = subject[subjectInt].questions
            controller.currentQuestionInt = current

        } else if (segue.identifier == "finishSelector") {
            let controller = segue.destination as! FinishViewController
            controller.total = total
        }
    }
    
}

class FinishViewController: UIViewController {
    var total = Int()
    @IBOutlet weak var descriptor: UILabel!
    
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(total/2 >= totalCorrect){
            descriptor.text = "Better luck next time"
        } else {
            descriptor.text = "Amazing"
        }
        
        score.text = String(totalCorrect) + " out of " + String(total)
        
        totalCorrect = 0
        subject = [Topic]()
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backToMain", sender: self)
    }
    
    
}
