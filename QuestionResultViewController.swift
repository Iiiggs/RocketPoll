//
//  QuestionResultViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 2/4/15.
//
//

import UIKit

class QuestionResultViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate
{
    var question:Question?
    var responses:[String:CGFloat] = ["One":0.4, "Two":0.3, "Three":0.2, "Four":0.1]
    let cellIdentifier = "questionResultCell"
    var totalAnswers:Int32 = 0
    var responseCounts  = [:]

    @IBOutlet weak var askedByImageView: UIImageView!

    @IBOutlet weak var askedByLabel: UILabel!

    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var votesLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        askedByLabel.text = self.question!.askedBy.username
        questionLabel.text = self.question!.text as String

        PFCloud.callFunctionInBackground("responseCountForQuestion", withParameters: ["questionId":question!.objectId!], block: { (result, error) -> Void in
            if error == nil {
                let resultDict = result as! NSDictionary
                self.totalAnswers = (resultDict.objectForKey("totalResponses") as! NSNumber).intValue
                self.votesLabel.text = "\(self.totalAnswers) votes"

                self.responseCounts = resultDict.objectForKey("responseCounts") as! NSDictionary

                self.tableView.reloadData()
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        })

        if self.question!.askedBy.objectForKey("profile_picture") != nil {
            let profilePictureFile = self.question!.askedBy.objectForKey("profile_picture") as! PFFile
            profilePictureFile.getDataInBackgroundWithBlock({ (profilePicData, error) -> Void in
                if error == nil {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.askedByImageView.image = UIImage(data: profilePicData)
                    })
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
            })

        }

        let totalCommentsQuery = PFQuery(className:"Comment")
        totalCommentsQuery.whereKey("question", equalTo: question!)
        totalCommentsQuery.countObjectsInBackgroundWithBlock { (commentsCount, error) -> Void in
            if error == nil {
                self.navigationItem.rightBarButtonItem?.title = "\(commentsCount) Comments"
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        }


        self.title = "Results"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action: "back")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Comment", style: UIBarButtonItemStyle.Done, target: self, action: "comment")


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.question!.options.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! QuestionResultTableViewCell
        cell.backgroundColor = UIColor.clearColor()

        let label = cell.viewWithTag(2) as! UILabel
        let option = self.question!.options[indexPath.row]
        label.text = option as String

        if responseCounts.objectForKey(option) != nil {
            let count = (responseCounts[option] as! NSNumber).integerValue
            if count == 1 {
                label.text = "\(option): \(count)"
            }
            else
            {
                label.text = "\(option): \(count)"
            }

            let width = CGFloat(count) / CGFloat(self.totalAnswers) * CGFloat(tableView.frame.width)

            cell.constWidth?.constant = width
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                cell.layoutIfNeeded()
            })

        }

        let constHeight = NSLayoutConstraint(item: cell.resultBar!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: cell.contentView, attribute: NSLayoutAttribute.Height,                 multiplier: 0.5, constant:0)
        cell.addConstraint(constHeight)

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(self.question!.options.count)
    }

    func comment() {
        // present comment view controller?
        let comments = self.storyboard!.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
        comments.question = self.question!
        // set the questoin?

        let navigation = UINavigationController(rootViewController: comments)

        self.presentViewController(navigation, animated: true, completion: nil)
    }

    func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
