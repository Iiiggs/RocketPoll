//
//  CommentsViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 3/14/15.
//
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "commentCell"
    var question:Question!
    var comments:[Comment] = []

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var commentTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: "dissmissKeyboard")
        self.view.addGestureRecognizer(tap)

        loadComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "liftMainViewWhenKeyboardAppears:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "returnMainViewWhenKeyboardAppears:", name:UIKeyboardWillHideNotification, object: nil)

    }

    func liftMainViewWhenKeyboardAppears(notification:NSNotification){
        let info = notification.userInfo as NSDictionary!
        let durationValue = info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber!
        let curveValue = info[UIKeyboardAnimationCurveUserInfoKey] as NSNumber!
        let endFrame = info[UIKeyboardFrameEndUserInfoKey] as NSValue!

        UIView.animateWithDuration(durationValue.doubleValue, animations: { () -> Void in
            self.toolbar.setTranslatesAutoresizingMaskIntoConstraints(true)

            self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x,
                                            endFrame.CGRectValue().origin.y - self.toolbar.bounds.size.height,
                                            self.toolbar.frame.size.width,
                                            self.toolbar.frame.size.height)
        })
    }

    func returnMainViewWhenKeyboardAppears(notification:NSNotification){
        let info = notification.userInfo as NSDictionary!
        let durationValue = info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber!
        let curveValue = info[UIKeyboardAnimationCurveUserInfoKey] as NSNumber!


        UIView.animateWithDuration(durationValue.doubleValue, animations: { () -> Void in
            self.toolbar.setTranslatesAutoresizingMaskIntoConstraints(true)
            self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x,
                self.view.bounds.size.height - self.toolbar.bounds.size.height,
                self.toolbar.frame.size.width,
                self.toolbar.frame.size.height)
        })
    }

    func dissmissKeyboard(){
        self.commentTextField.resignFirstResponder()
    }


    @IBAction func postTapped(sender: AnyObject) {
        var comment = Comment()
        comment.text = self.commentTextField.text
        comment.by = PFUser.currentUser()
        comment.question = self.question
        comment.saveEventually()

        var data = ["alert":"Your question got a new comment from \(PFUser.currentUser().username): \"\(comment.text)\"",
            "badge":"Increment"]
        var push = PFPush()
        push.setData(data)
        push.setChannel("answers_to_\(question.askedBy.objectId)")
        push.sendPushInBackgroundWithBlock(nil)


        self.comments.append(comment)
        self.tableView.reloadData()
    }


    func loadComments(){
        var query = PFQuery(className: "Comment")
        query.whereKey("question", equalTo: self.question!)
        query.includeKey("answeredBy")
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
}
