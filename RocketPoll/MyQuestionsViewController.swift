//
//  MyQuestionsViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 1/24/15.
//
//

import UIKit

class MyQuestionsViewController: PollingViewControllerBase, UITableViewDataSource, UITableViewDelegate, UIToolbarDelegate, AskingNewQuestionDelegate {

    @IBOutlet weak var myQuestionsTableView: UITableView!

    let cellIdentifier = "myQuestionCell"

    var myQuestions: [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewWillAppear(animated: Bool) {
        getMyQuestions()
    }

    func getMyQuestions(){
        if(PFUser.currentUser() != nil){
            var query = PFQuery(className: "Question")
            query.whereKey("askedBy", equalTo: PFUser.currentUser())
            query.orderByDescending("createdAt")
            query.includeKey("askedBy")

            query.findObjectsInBackgroundWithBlock { (myQuestions, error) -> Void in
                if error == nil {
                    self.myQuestions = myQuestions as [Question]

                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.myQuestionsTableView.reloadData()
                    })
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            }
        }
        else {
            presentLoginViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as MyQuestionTableViewCell

        cell.questionLabel.text = myQuestions[indexPath.row].text
        cell.backgroundColor = UIColor.clearColor()

        var questionId = myQuestions[indexPath.row].objectId
        PFCloud.callFunctionInBackground("countAnswerForQuestion", withParameters: ["questionId":questionId]) { (result, error) -> Void in
            if error == nil {
                let count = result["totalResponses"] as NSNumber

                cell.responseCount.text = count.description
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myQuestions.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let questionResult = self.storyboard!.instantiateViewControllerWithIdentifier("QuestionResultViewController") as QuestionResultViewController
        questionResult.question = self.myQuestions[indexPath.row]
        var navigation = UINavigationController(rootViewController: questionResult)
        self.presentViewController(navigation, animated: true, completion: nil)
    }


    @IBAction func askNewQuestion(sender: AnyObject) {
        var askQuestion = self.storyboard!.instantiateViewControllerWithIdentifier("AskQuestionViewController") as AskQuestionViewController
        askQuestion.delegate = self

        var navigation = UINavigationController(rootViewController: askQuestion)

        self.presentViewController(navigation, animated: true, completion: nil)
    }

    func doneAskingNewQuestion(){
        getMyQuestions()
    }

}
