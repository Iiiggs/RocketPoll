//
//  DevToolsViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 1/1/15.
//
//

import UIKit

class DevToolsViewController: PollingViewControllerBase {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func askSampleQuestion(sender: AnyObject) {
        DataController.sharedInstance.askQuestion("What should I wear tonight?", options: ["Something blue", "Something black", "Something purple"], friends: [])
    }

    @IBAction func submitSampleAnswer(sender: AnyObject) {
        let sampleQuestion = Question(text:"What should I wear tonight?", options: NSOrderedSet(objects:["Something blue", "Something black", "Something purple"]), askedBy: PFUser())


        DataController.sharedInstance.answerQuestion(Answer(question: sampleQuestion.text, option:"Something black"))
    }

    @IBAction func readResults(sender: AnyObject) {
        DataController.sharedInstance.getAnswersWithBlock { (answers, error) -> Void in
            if error == nil {
                UIAlertView(title: "Success", message: "Found \(answers.count) answers", delegate: nil, cancelButtonTitle: "OK").show()
            }
            else{
                UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }

    @IBAction func countResults(sender: AnyObject) {
        DataController.sharedInstance.countAnswersWithBlock { (answerCounts, error) -> Void in
            if error == nil {
                var answersString = ""
                for answer in answerCounts{
                    answersString = answersString.stringByAppendingString("\(answer.key): \(answer.value) \n")
                }
                UIAlertView(title: "Success", message: answersString, delegate: nil, cancelButtonTitle: "OK").show()
            }
            else{
                UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
}
