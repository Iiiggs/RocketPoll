//
//  CommentsViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 3/14/15.
//
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate , UITextFieldDelegate{

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

        self.title = "New Comment"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "post")

        self.commentTextField.becomeFirstResponder()
        self.commentTextField.delegate = self

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
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
                                            self.view.frame.size.width,
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


    func post() {
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

        self.commentTextField.text = ""

        dissmissKeyboard()
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
        let font = UIFont.systemFontOfSize(17)
        let suggestedHeight = heightForView(
            text,
            font: font,
            width: self.tableView.frame.width - 100// roughly what's configured in the auto layout contstraints
            ) + 60 // for top/bottom margin

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

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Bottom
    }
}
