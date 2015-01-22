//
//  SeeResultsViewController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit
import CoreData

class SeeResultsViewController: PollingViewControllerBase,
    UITableViewDelegate,
    UITableViewDataSource {
//    var responseCounts: NSDictionary = NSDictionary()
    var questionsWithResponseCounts: NSDictionary = NSDictionary()

    let cellIdentifier = "questionResponse"

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getResponseData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        getResponseData()
    }

    func getResponseData(){
        DataController.sharedInstance.countAnswersWithBlock { (responseCounts, error) -> Void in
            if error == nil {
                self.questionsWithResponseCounts = responseCounts
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadData()
                })
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        }

//        DataController.sharedInstance.getAnswersWithBlock { (answers, error) -> Void in
//            if error == nil {
//                self.answers = answers
//            }
//            else {
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
//                })
//            }
//        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as ResponseCountCell
        cell.backgroundColor = UIColor.clearColor()

        let questionKey = questionsWithResponseCounts.allKeys[indexPath.section] as String
        let responses = questionsWithResponseCounts[questionKey] as NSDictionary
        let responsesKey = responses.allKeys[indexPath.row] as String
        let responsesValue = responses[responsesKey] as CGFloat

        cell.responseLabel.text = "\(responsesKey) (\(Int(responsesValue)))"
        cell.responseLabel.font = UIFont(name: "Chalkboard SE", size: 10 + responsesValue)
//        cell.responseLabel.font = UIFont.(10 + responsesValue)

        // basic label of option and count
//        let key = self.responseCounts.allKeys[indexPath.row] as String
//        cell.textLabel!.text = key
//        cell.detailTextLabel!.text = self.responseCounts.objectForKey(key)?.description


        // group table view by question
        // cell for each option with count
        // or
        // size cell option size by count


        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = questionsWithResponseCounts.allKeys[section] as String
        let responses = questionsWithResponseCounts[key] as NSDictionary
        return responses.count
    }

//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 100
//    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return questionsWithResponseCounts.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return questionsWithResponseCounts.allKeys[section] as String
    }
    
}
