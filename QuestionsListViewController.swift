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
    var visibleAnsweredQuestoin:[Question] {
        return answeredQuestions.filter { (question) -> Bool in
            for q in self.hiddenQuestions {
                if (q.objectId == question.objectId) {
                    return false
                }
            }

            return true
        }
    }
    var unansweredQuestions:[Question] = []
    var visibleUnansweredQuestoin:[Question] {
        return unansweredQuestions.filter { (question) -> Bool in
            for q in self.hiddenQuestions {
                if (q.objectId == question.objectId) {
                    return false
                }
            }

            return true
        }
    }

    var hiddenQuestions:[Question] = []
    var combinedQuestions:[Question] {
        get {
            return (visibleUnansweredQuestoin + visibleAnsweredQuestoin)
        }
    }

    @IBOutlet weak var questionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        getQuestions()
    }

    override func viewWillAppear(animated: Bool) {
        getQuestions()
    }

    var fetchingAnsweredQuestions = false
    var fetchingUnansweredQuestions = false

    func getQuestions(){
        let user = PFUser.currentUser()
        if user != nil {
            if (user.objectForKey("hiddenQuestions") != nil){
                let hiddenQuestions =  user.objectForKey("hiddenQuestions") as [Question]
                self.hiddenQuestions = hiddenQuestions

                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.questionsTableView.reloadData()
                })
            }

            self.fetchingUnansweredQuestions = true
            PFCloud.callFunctionInBackground("unansweredQuestions", withParameters: [:], block: { (result, error) -> Void in
                if error == nil {
                    // assign the results locally and flag that we're done
                    self.unansweredQuestions = result as [Question]
                    self.fetchingUnansweredQuestions = false

                    // update the ui if we're done with both queries
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        if (!self.fetchingAnsweredQuestions && !self.fetchingUnansweredQuestions){
//                            self.hiddenQuestions = []
                            self.questionsTableView.reloadData()
                        }
                    })
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })

            self.fetchingAnsweredQuestions = true
            PFCloud.callFunctionInBackground("answeredQuestions", withParameters: [:], block: { (result, error) -> Void in
                if error == nil {
                    // assign the results locally and flag that we're done
                    self.answeredQuestions = result as [Question]
                    self.fetchingAnsweredQuestions = false

                    // update the ui if we're done with both queries
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        if (!self.fetchingAnsweredQuestions && !self.fetchingUnansweredQuestions){
//                            self.hiddenQuestions = []
                            self.questionsTableView.reloadData()
                        }

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
    }

    func doneAnsweringQuestion() {
        getQuestions()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return combinedQuestions.count
    }

//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 40
//    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.questionsTableView.dequeueReusableCellWithIdentifier("questionListCell") as QuestionListTableViewCell

        cell.backgroundColor = UIColor.clearColor()

        let question = combinedQuestions[indexPath.row]

        cell.questionTextLabel.text = question.text
        if indexPath.row < visibleUnansweredQuestoin.count {
            cell.accessoryType = .None
        }
        else {
            cell.accessoryType = .Checkmark
        }
        cell.askedByTextLabel.text = question.askedBy.username
        cell.askedDateTextLabel.text = question.createdAt.timeAgo


        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let question = self.combinedQuestions[indexPath.row]

        if indexPath.row < visibleUnansweredQuestoin.count {
            var storyboard = self.storyboard!
            var answerQuestionViewController = storyboard.instantiateViewControllerWithIdentifier("AnswerQuestionViewController") as AnswerQuestionViewController
            answerQuestionViewController.question = question
            answerQuestionViewController.delegate = self
            var navigation = UINavigationController(rootViewController: answerQuestionViewController)
            self.presentViewController(navigation, animated: true, completion: nil)
        } else {
            let questionResult = self.storyboard!.instantiateViewControllerWithIdentifier("QuestionResultViewController") as QuestionResultViewController
            questionResult.question = question
            let navigation = UINavigationController(rootViewController: questionResult)
            self.presentViewController(navigation, animated: true, completion: nil)

        }
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        return [
            UITableViewRowAction(style: .Default, title: "Hide", handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                let question = self.combinedQuestions[indexPath.row]
                self.hiddenQuestions.append(question)

                // submit this as opted out
                PFUser.currentUser().setObject(self.hiddenQuestions, forKey: "hiddenQuestions")
                PFUser.currentUser().saveInBackgroundWithBlock(nil)

                // hide it from the ui
                self.questionsTableView.beginUpdates()
                self.questionsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
                self.questionsTableView.endUpdates()
            }),
        ]
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Intentionally blank. Required to use UITableViewRowActions
    }

}
