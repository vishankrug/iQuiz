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

