//
//  CommentsViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 3/14/15.
//
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate , UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "commentCell"
    var question:Question!
    var comments:[Comment] = []

    @IBOutlet weak var commentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tap)

        loadComments()

        self.title = "Comments"

        hideCommentView()
    }

    func hideCommentView(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Done, target: self, action: "showCommentView")

        self.commentTextView.resignFirstResponder()
        self.commentTextView.delegate = self
        self.commentTextView.hidden = true
    }

    func showCommentView(){
        self.commentTextView.becomeFirstResponder()
        self.commentTextView.hidden = false

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "hideCommentView")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "postComment")
    }

    func hideKeyboard(){
        self.commentTextView.resignFirstResponder()
    }

    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func postComment() {
        if !self.commentTextView.text.isEmpty {
            var comment = Comment()
            comment.text = self.commentTextView.text
            comment.by = PFUser.currentUser()
            comment.question = self.question
            comment.saveEventually()

            if self.question.askedBy != PFUser.currentUser() {
                var data = ["alert":"Your question got a new comment from \(PFUser.currentUser().username): \"\(comment.text)\"",
                    "badge":"Increment"]
                var push = PFPush()
                push.setData(data)
                push.setChannel("answers_to_\(question.askedBy.objectId)")
                push.sendPushInBackgroundWithBlock(nil)
            }

            self.comments.insert(comment, atIndex:0)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)

            self.commentTextView.text = ""

            hideCommentView()
        }
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func loadComments(){
        var query = PFQuery(className: "Comment")
        query.whereKey("question", equalTo: self.question!)
        query.includeKey("answeredBy")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (comments, error) -> Void in
            if error == nil {
                self.comments = comments as [Comment]!
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }

            self.tableView.reloadData()

            println("Found \(self.comments.count) comments")

        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as CommentsTableViewCell

        cell.commentTextLabel.text = self.comments[indexPath.row].text
        cell.commentDateLabel.text = self.comments[indexPath.row].createdAt?.timeAgo
        cell.byTextLabel.text = self.comments[indexPath.row].by.username
        if self.comments[indexPath.row].by.objectForKey("profile_picture") != nil {
            let profilePictureFile = self.comments[indexPath.row].by.objectForKey("profile_picture") as PFFile
            profilePictureFile.getDataInBackgroundWithBlock({ (profilePicData, error) -> Void in
                if error == nil {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        cell.profilePictureImageView.image = UIImage(data:profilePicData)
                    })
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })
        }

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let text = self.comments[indexPath.row].text
        let font = UIFont.systemFontOfSize(14)
        let suggestedHeight = heightForView(
            text,
            font: font,
            width: self.tableView.frame.width - 100// roughly what's configured in the auto layout contstraints
            )  // for top/bottom margin

        return max(suggestedHeight, 100)
    }

    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
}
