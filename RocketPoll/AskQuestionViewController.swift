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


class AskQuestionViewController: PollingViewControllerBase, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FriendsPickerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "answerOption"

//    var text: NSString = ""
    var options: [NSString] = ["", ""]
    var optionTextFields: NSMutableSet = NSMutableSet()

    var questionText: NSString = ""
    var questionOptionsText: [NSString] = []

    var activeTextField: UITextField?

    @IBOutlet weak var questionTextView: UITextView!
    
    var delegate: AskingNewQuestionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad() 

        // Do any additional setup after loading the view.
        self.optionTextFields = NSMutableSet()

        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

        self.title = "New Question"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ask", style: UIBarButtonItemStyle.Done, target: self, action: "ask")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "liftMainViewWhenKeyboardAppears:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "returnMainViewWhenKeyboardAppears:", name:UIKeyboardWillHideNotification, object: nil)
    }


    func liftMainViewWhenKeyboardAppears(notification:NSNotification){
        if activeTextField == nil { // because it means we're typing in the question text view
            return
        }

        let info = notification.userInfo as NSDictionary!
        let kbSize = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
        let contentInsets = UIEdgeInsets(top:0.0, left:0.0, bottom:kbSize!.height, right:0.0)
        self.tableView.contentInset = contentInsets

        let textViewPosition = activeTextField!.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(textViewPosition)
        self.tableView.scrollToRowAtIndexPath(indexPath!, atScrollPosition: UITableViewScrollPosition.None, animated: true)
    }

    func returnMainViewWhenKeyboardAppears(notification:NSNotification){
        self.tableView.contentInset = UIEdgeInsetsZero
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.activeTextField = nil
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view!.isKindOfClass(UIControl.self) {
            return false
        }
        else if touch.view!.superview!.isKindOfClass(UITableViewCell.self) {
            return false
        }

        return true
    }

    func dismissKeyboard(){
        self.questionTextView.resignFirstResponder()
        self.activeTextField?.resignFirstResponder()
    }

    func cancel() {
        dismissKeyboard()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func ask() {

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
            let option_text = (optionTextField as! UITextField).text!

            if(option_text.characters.count == 0){
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
                let storyboard = self.storyboard!

                let friendsListViewController = storyboard.instantiateViewControllerWithIdentifier("FriendsListViewController") as! FriendsListViewController

                friendsListViewController.friends = users
                friendsListViewController.delegate = self


                let navigation = UINavigationController(rootViewController: friendsListViewController)

                self.presentViewController(navigation, animated: true, completion: nil)
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

        let question = Question(className:"Question")
        question.text = self.questionText
        question.options = self.questionOptionsText
        question.askedOf = friends
        question.askedBy = PFUser.currentUser()
        question.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                for friend in friends {
                    let data = ["alert": "You have a new question from \(PFUser.currentUser().username)",
                        "badge":"Increment"]
                    let push = PFPush()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! AnswerOptionTableViewCell

        cell.backgroundColor = UIColor.clearColor()

        let textField = cell.viewWithTag(10) as! UITextField


        let label = cell.viewWithTag(20) as! UILabel



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
            textField.text = options[indexPath.row] as String

            optionTextFields.addObject(textField)
        }


        return cell
    }

    var currentIndexPath:NSIndexPath?

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        if(indexPath.row == options.count) // tapped +
        {
            options = []
            for optionTextField in self.optionTextFields {
                options.append((optionTextField as! UITextField).text!)
            }

            options.append("") // will add a new row
            tableView.reloadData()
        }
        else
        {
            currentIndexPath = indexPath
        }
    }

}
