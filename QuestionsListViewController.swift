//
//  QuestionsListViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 1/12/15.
//
//

import UIKit

class QuestionsListViewController: PollingViewControllerBase, UITableViewDelegate, UITableViewDataSource {

    var questions:[Question] = []

    @IBOutlet weak var questionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        getQuestions()
    }

    override func viewWillAppear(animated: Bool) {
        getQuestions()
    }


    func getQuestions(){
        var query = PFQuery(className:"Question")
        query.whereKey("askedOf", equalTo: PFUser.currentUser())
        query.orderByAscending("createdAt")
        query.includeKey("createdBy")
        query.findObjectsInBackgroundWithBlock{ (questions, error) -> Void in
            if error == nil {
                self.questions = questions as [Question]
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.questionsTableView.reloadData()
                })
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return questions.count
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.questionsTableView.dequeueReusableCellWithIdentifier("questionListCell") as QuestionListTableViewCell

        cell.backgroundColor = UIColor.clearColor()

        cell.textLabel!.text = questions[indexPath.row].text

        let createdByUser = questions[indexPath.row].objectForKey("createdBy") as PFUser
        cell.detailTextLabel!.text = createdByUser.username

//        var user:PFUser = questions[indexPath.row].askedBy
//        user.fetchInBackgroundWithBlock { (user, error) -> Void in
//            if error == nil {
//                let askingUserName = user.objectForKey("username") as String
//                cell.textLabel!.text = "question from \(askingUserName)"
//            }
//            else
//            {
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
//                })
//            }
//        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let question = questions[indexPath.row]

        var storyboard = self.storyboard!

        var answerQuestionViewController = storyboard.instantiateViewControllerWithIdentifier("AnswerQuestionViewController") as AnswerQuestionViewController

        answerQuestionViewController.currentQuestion = question

        self.presentViewController(answerQuestionViewController, animated: true, completion: nil)
    }




}
