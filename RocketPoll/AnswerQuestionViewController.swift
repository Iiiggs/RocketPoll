	//
//  AnswerQuestionViewController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit
import CoreData

protocol AnswerQuestionDelegate{
    func doneAnsweringQuestion()
}


class AnswerQuestionViewController: PollingViewControllerBase, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    let cellIdentifier = "answerOption"

    var question: Question?
    var selectedOptionIndex: Int = -1

    var delegate : AnswerQuestionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.questionLabel.text = self.question?.text
    }


    @IBAction func click(sender: AnyObject) {
        if(selectedOptionIndex != -1)
        {
            // submit
            let answer = Answer()
            answer.question = self.question!
            answer.question = self.question!
            answer.selection = self.question!.options[self.selectedOptionIndex] as String!
            answer.answeredBy = PFUser.currentUser()
            
            answer.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    if self.question!.answers == nil {
                        self.question!.answers = []
                    }
                    if self.question!.answeredBy == nil {
                        self.question!.answeredBy = []
                    }
                    self.question!.answers!.append(answer)
                    self.question!.answeredBy!.append(PFUser.currentUser())
                    self.question?.saveInBackgroundWithBlock(nil)
                }
                else{
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })

            let asker = answer
            var push = PFPush()
            push.setChannel("answers_to_\(answer.question.askedBy.objectId)")
            push.setMessage("You have a new response to \"\(answer.question.text)\"")
            push.sendPushInBackgroundWithBlock(nil)

            // navigate back to question list
            self.delegate!.doneAnsweringQuestion()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.question!.options.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell

        cell.backgroundColor = UIColor.clearColor()

        cell.textLabel!.text = self.question!.options[indexPath.row] as String!

        cell.accessoryType = .None
        if(indexPath.row == selectedOptionIndex)
        {
            cell.accessoryType = .Checkmark
        }

        return cell
    }
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        selectedOptionIndex = indexPath.row
//        self.currentOption = self.currentOptions.objectAtIndex(selectedOptionIndex) as Option!
        tableView.reloadData()
    }



}
