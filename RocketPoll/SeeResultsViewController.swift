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

        getMyQuestions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
    }

    func getMyQuestions(){
//        self.questionsWithResponseCounts =

    }

    func getResponseData(){
        self.questionsWithResponseCounts =
                    ["Where should I eat tonight?":                          ["McDonalds": 1,
                        "Burger King": 3,
                        "Fugo De Chao": 12,
                        "Thai Place": 3,
                        "Spookey Sushi": 0,
                        "Yobagoya": 1,
                        "C.B. Potts": 4],
                    "Should we go skiiing this weekend?" :
                        ["Yes": 3,
                        "No": 0,
                        "Maybe": 2]]

//        DataController.sharedInstance.countAnswersWithBlock { (responseCounts, error) -> Void in
//            if error == nil {
//                self.self.questionsWithResponseCounts = responseCounts
//            }
//            else {
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK").show()
//                })
//            }
//        }

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
        cell.responseLabel.font = UIFont.systemFontOfSize(10 + responsesValue)

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
