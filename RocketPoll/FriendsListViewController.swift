//
//  FriendsListViewController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 12/23/14.
//
//

import UIKit

class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user: FBGraphUser?
    var friends = NSArray()
    let cellIdentifier = "friendsCell"
    var delegate: FriendsPickerDelegate?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getMySocialPollingFriends()

        self.tableView.registerClass(FacebookFriendsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }


    func sendRequestsToFriends(){
        FBWebDialogs.presentFeedDialogModallyWithSession(PFFacebookUtils.session(), parameters: nil, handler: { (result, url, error) -> Void in
            if error == nil{
                println(result)
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        })
    }

    func getMySocialPollingFriends(){
        FBRequestConnection.startWithGraphPath("/\(user!.objectID)/friends/", completionHandler: { (connection, result, error) -> Void in
            if error == nil{
                let resultDataArray = (result as NSDictionary)["data"]! as NSArray

                self.friends = resultDataArray
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadData()
                })
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }

        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.friends.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell

        cell.backgroundColor = UIColor.clearColor()

        cell.textLabel!.text = self.friends[indexPath.row].objectForKey("name") as? String

        return cell
    }

    @IBAction func donePickingFriends(sender: AnyObject) {
        let selectedIndexPaths = self.tableView.indexPathsForSelectedRows() as [NSIndexPath]?
        if selectedIndexPaths != nil {
            var selectedUsers: NSMutableArray = []
            for i:NSIndexPath in selectedIndexPaths!{
                let userId = friends[i.row].objectForKey("id") as String
                selectedUsers.addObject(userId)
            }

            self.delegate?.donePickingFriends(selectedUsers)

            self.dismissViewControllerAnimated(true, completion: nil)
        }


        self.dismissViewControllerAnimated(true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
