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

        // Do any additional setup after loading the view.
//        myQuestionsTableView.registerClass(MyQuestionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        getMyQuestions()
    }

    func getMyQuestions(){
        var query = PFQuery(className: "Question")
//        query.whereKey("createdBy", equalTo: PFUser.currentUser())
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as MyQuestionTableViewCell

        println(myQuestions[indexPath.row].text)
        cell.questionLabel.text = myQuestions[indexPath.row].text


        cell.backgroundColor = UIColor.clearColor()

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myQuestions.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let options = self.myQuestions[indexPath.row].options

        UIAlertView(title: "Options", message: options.description, delegate: nil, cancelButtonTitle: "OK").show()
    }

    @IBAction func askNewQuestion(sender: AnyObject) {
        let askQuestion = self.storyboard!.instantiateViewControllerWithIdentifier("AskQuestionViewController") as AskQuestionViewController
        askQuestion.delegate = self
        self.presentViewController(askQuestion, animated: true, completion: nil)
    }

    func doneAskingNewQuestion(){
        getMyQuestions()
    }

}
