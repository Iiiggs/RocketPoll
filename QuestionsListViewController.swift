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

        self.questionsTableView.registerClass(QuestionListTableViewCell.self, forCellReuseIdentifier: "questionListCell")

        DataController.sharedInstance.getQuestionsWithBlock { (questions, error) -> Void in
            if error == nil {
                self.questions = questions
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
        var cell = self.questionsTableView.dequeueReusableCellWithIdentifier("questionListCell") as UITableViewCell

        var user:PFUser = questions[indexPath.row].askedBy
        user.fetchIfNeeded()

        cell.textLabel!.text = user.objectForKey("username") as String

        return cell
    }
}
