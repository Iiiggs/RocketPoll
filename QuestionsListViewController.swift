//
//  QuestionsListViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 1/12/15.
//
//

import UIKit

class QuestionsListViewController: PollingViewControllerBase, UITableViewDelegate, UITableViewDataSource, AnswerQuestionDelegate {

    var answeredQuestions:[Question] = []
    var unansweredQuestions:[Question] = []



    @IBOutlet weak var questionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        getQuestions()
    }

    override func viewWillAppear(animated: Bool) {
        getQuestions()
    }


    func getQuestions(){
        if PFUser.currentUser() != nil {

            PFCloud.callFunctionInBackground("unansweredQuestions", withParameters: [:], block: { (result, error) -> Void in
                if error == nil {
                    self.unansweredQuestions = result as [Question]
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.questionsTableView.reloadData()
                    })
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })

            PFCloud.callFunctionInBackground("answeredQuestions", withParameters: [:], block: { (result, error) -> Void in
                if error == nil {
                    self.answeredQuestions = result as [Question]
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.questionsTableView.reloadData()
                    })
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })

        }
        else {
            presentLoginViewController()
        }


//        var query = PFQuery(className:"Question")
//        query.whereKey("askedOf", equalTo: PFUser.currentUser())
//
//        // exclude ones I've already answered - how to handle parse limits here?
//        var myAnswers = PFQuery(className: "Answer")
//        myAnswers.whereKey("answeredBy", equalTo: PFUser.currentUser())
//
//        let answers = myAnswers.findObjects()
//
//        query.orderByAscending("createdAt")
//
//        query.includeKey("askedBy")




//        query.findObjectsInBackgroundWithBlock{ (questions, error) -> Void in
//            if error == nil {
//                self.questions = questions as [Question]
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.questionsTableView.reloadData()
//                })
//            }
//            else {
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
//                })
//            }
//        }
//        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return unansweredQuestions.count + answeredQuestions.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.questionsTableView.dequeueReusableCellWithIdentifier("questionListCell") as QuestionListTableViewCell

        cell.backgroundColor = UIColor.clearColor()

        if indexPath.row < unansweredQuestions.count {
            cell.textLabel!.text = unansweredQuestions[indexPath.row].text
            cell.accessoryType = UITableViewCellAccessoryType.None
            let createdByUser = unansweredQuestions[indexPath.row].askedBy
            createdByUser.fetchIfNeededInBackgroundWithBlock { (user, error) -> Void in
                if error == nil {
                    cell.detailTextLabel!.text = createdByUser.username
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            }
        }
        else {
            let index = indexPath.row - unansweredQuestions.count
            cell.textLabel!.text = answeredQuestions[index].text
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            let createdByUser = answeredQuestions[index].askedBy
            createdByUser.fetchIfNeededInBackgroundWithBlock { (user, error) -> Void in
                if error == nil {
                    cell.detailTextLabel!.text = createdByUser.username
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            }

        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < unansweredQuestions.count {
            let question = unansweredQuestions[indexPath.row]
            var storyboard = self.storyboard!
            var answerQuestionViewController = storyboard.instantiateViewControllerWithIdentifier("AnswerQuestionViewController") as AnswerQuestionViewController
            answerQuestionViewController.question = question
            answerQuestionViewController.delegate = self
            self.presentViewController(answerQuestionViewController, animated: true, completion: nil)
        } else {
            let index = indexPath.row - unansweredQuestions.count

            let questionResult = self.storyboard!.instantiateViewControllerWithIdentifier("QuestionResultViewController") as QuestionResultViewController
            questionResult.question = self.answeredQuestions[index]
            self.presentViewController(questionResult, animated: true, completion: nil)

        }
    }


    func doneAnsweringQuestion() {
        getQuestions()
    }

}
