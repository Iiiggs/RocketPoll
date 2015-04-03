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
    var friends: [PFUser] = []
    let cellIdentifier = "friendCell"
    var delegate: FriendsPickerDelegate?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.getMySocialPollingFriends()

        self.tableView.registerClass(FriendTableViewCell.self, forCellReuseIdentifier: cellIdentifier)


        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "done")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }


    func sendRequestsToFriends(){
        FBWebDialogs.presentFeedDialogModallyWithSession(PFFacebookUtils.session(), parameters: nil, handler: { (result, url, error) -> Void in
            if error == nil{
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        })
    }

//    func getMySocialPollingFriends(){
//        FBRequestConnection.startWithGraphPath("/\(user!.objectID)/friends/", completionHandler: { (connection, result, error) -> Void in
//            if error == nil{
//                let resultDataArray = (result as NSDictionary)["data"]! as NSArray
//
//                self.friends = resultDataArray
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.tableView.reloadData()
//                })
//            }
//            else {
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
//                })
//            }
//
//        })
//    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.friends.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as FriendTableViewCell

        let selectedIndexPaths = self.tableView.indexPathsForSelectedRows() as [NSIndexPath]?

        cell.backgroundColor = UIColor.clearColor()

        cell.textLabel!.text = self.friends[indexPath.row].objectForKey("username") as? String

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        cell?.selected = true

//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func done() {
        let selectedIndexPaths = self.tableView.indexPathsForSelectedRows() as [NSIndexPath]?
        if selectedIndexPaths != nil {
            var selectedUsers: [PFUser] = []
            for i:NSIndexPath in selectedIndexPaths!{
                selectedUsers.append(friends[i.row])
            }

            self.delegate?.donePickingFriends(selectedUsers)
        }
    }

    func cancel (){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
