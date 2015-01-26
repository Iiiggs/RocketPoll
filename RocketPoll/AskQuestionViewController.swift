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
    var options: [NSString] = []
    var optionTextFields: NSMutableSet = NSMutableSet()
    @IBOutlet weak var questionTextView: UITextView!

    var delegate: AskingNewQuestionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad() 

        // Do any additional setup after loading the view.
        self.optionTextFields = NSMutableSet()

//        self.displayLastQuestion()
    }
    @IBAction func askClicked(sender: AnyObject) {
        // show friends list to pick who to send to
        self.showFriendsList()
        // give user feedback
    }

//    @IBAction func click(sender: AnyObject){
//        self.text = questionTextField.text
//        self.options



//        var question = PFObject(className: "Question")



//        question.setObject(self.text, forKey: "text")

//        var relation = question.relationForKey("options")
//        for o in self.options{
//            var option = PFObject(className: "Option")
//            option.setObject(o, forKey: "text")
//            option.save()
//            relation.addObject(option)
//        }
//        question.save()

//        var trigger =  PFObject(className: "Trigger")
//        trigger.setObject(question, forKey: "question")
//        trigger.save()
        // save text and options to Parse


        // show friends list
//        showFriendsList()

        // for now, go to next page
//        showSwipeRight()


//    }

    func showFriendsList(){

//        let appDelegate = UIApplication.sharedApplication().delegate! as PollingAppDelegate

//        // TODO: Figure out a way to show Parse friends instead
//        if appDelegate.facebookUser != nil {

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
        let text = self.questionTextView.text

        // grab the options list from the ui
        var options:NSMutableArray = []
        for optionTextField in self.optionTextFields {
            options.addObject((optionTextField as UITextField).text)
        }

        DataController.sharedInstance.askQuestion(text, options: options, friends: friends)
        // re-write this here ^

        // dismiss friends picker
        self.dismissViewControllerAnimated(true, completion: nil)

        // dismiss
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
}
