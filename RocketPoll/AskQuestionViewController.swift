//
//  EditQuestionViewController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit
import CoreData

protocol FriendsPickerDelegate{
    func donePickingFriends(friends:[PFUser])
}

protocol AskingNewQuestionDelegate{
    func doneAskingNewQuestion()
}


class AskQuestionViewController: PollingViewControllerBase, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FriendsPickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "answerOption"

//    var text: NSString = ""
    var options: [NSString] = ["", ""]
    var optionTextFields: NSMutableSet = NSMutableSet()

    var questionText: NSString = ""
    var questionOptionsText: [NSString] = []

    @IBOutlet weak var questionTextView: UITextView!

    var delegate: AskingNewQuestionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad() 

        // Do any additional setup after loading the view.
        self.optionTextFields = NSMutableSet()

//        self.displayLastQuestion()
    }
    @IBAction func askClicked(sender: AnyObject) {

        self.questionText = self.questionTextView.text as NSString
        if self.questionText.length == 0 {
            UIAlertView(title: "Error", message: "Please enter a question", delegate: nil, cancelButtonTitle: "OK").show()

            return
        }



        // grab the options list from the ui
        if optionTextFields.count == 0 {
            UIAlertView(title: "Error", message: "Please add some options", delegate: nil, cancelButtonTitle: "OK").show()

            return
        }

        for optionTextField in self.optionTextFields {
            let option_text = (optionTextField as UITextField).text as NSString

            if(option_text.length == 0){
                UIAlertView(title: "Error", message: "Please fill out every option", delegate: nil, cancelButtonTitle: "OK").show()

                return
            }
            
            questionOptionsText.append(option_text)
        }


        // show friends list to pick who to send to
        self.showFriendsList()
        // give user feedback
    }

    func showFriendsList(){

        DataController.sharedInstance.getCurrentUserFriendsWithBlock { (users, error) -> Void in
            if error == nil {
                var storyboard = self.storyboard!

                var friendsListViewController = storyboard.instantiateViewControllerWithIdentifier("FriendsListViewController") as FriendsListViewController

                friendsListViewController.friends = users
                friendsListViewController.delegate = self

                
                self.presentViewController(friendsListViewController, animated: true, completion: nil)
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        }


    }

    func donePickingFriends(friends: [PFUser]) {
        // grab question from the ui

        var question = Question()
        question.text = self.questionText
        question.options = self.questionOptionsText
        question.askedOf = friends
        question.askedBy = PFUser.currentUser()
        question.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                for friend in friends {
                    var data = ["alert": "You have a new question from \(PFUser.currentUser().username)",
                        "badge":"Increment"]
                    var push = PFPush()
                    push.setData(data)
                    push.setChannel("questions_to_\(friend.objectId)")
                    push.sendPushInBackgroundWithBlock(nil)
                }
            }
        }

        // dismiss friends picker
        self.dismissViewControllerAnimated(true, completion: nil)

        // dismiss ask questions view controller
        self.presentingViewController?.dismissViewControllerAnimated(false, completion: { () -> Void in
            self.delegate!.doneAskingNewQuestion()
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return options.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as AnswerOptionTableViewCell

        cell.backgroundColor = UIColor.clearColor()

        var textField = cell.viewWithTag(10) as UITextField

        var label = cell.viewWithTag(20) as UILabel

        if(indexPath.row == options.count)
        {
            textField.hidden = true
            label.text = "+"
        }
        else
        {
            textField.hidden = false
            label.hidden = true
            textField.delegate = self
            textField.text = options[indexPath.row]
            optionTextFields.addObject(textField)
        }


        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        if(indexPath.row == options.count) // tapped +
        {
            options = []
            for optionTextField in self.optionTextFields {
                options.append((optionTextField as UITextField).text)
            }

            options.append("") // will add a new row
            tableView.reloadData()
        }
        else
        {

        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
