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
    var responses: [Answer]? = []

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
        let appDelegate = UIApplication.sharedApplication().delegate as PollingAppDelegate
        let managedContext = appDelegate.managedObjectContext!

        let fetchRequest = NSFetchRequest(entityName:"Answer")
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [Answer]

        if let results = fetchedResults {
            if results.count > 0
            {
                responses = []
                for response: Answer in results {
                    println("\(response.question.text) \(response.option.text)")

                    responses!.append(response)
                }

                self.tableView.reloadData()
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell

        cell.backgroundColor = UIColor.clearColor()

        cell.textLabel!.text = self.responses![indexPath.row].question.text
        cell.detailTextLabel!.text = self.responses![indexPath.row].option.text

        return cell
    }
}
