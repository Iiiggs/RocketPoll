	//
//  AnswerQuestionViewController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit
import CoreData

class AnswerQuestionViewController: PollingViewControllerBase, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    let cellIdentifier = "answerOption"

    var currentQuestion: Question?
    var selectedOptionIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.questionLabel.text = self.currentQuestion?.text
    }


    @IBAction func click(sender: AnyObject) {
        if(selectedOptionIndex != -1)
        {
            // submit
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.currentQuestion!.options.count
    }

    override func viewWillAppear(animated: Bool) {
//        displayLastQuestion()
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell

        cell.backgroundColor = UIColor.clearColor()

        cell.textLabel!.text = self.currentQuestion?.options.objectAtIndex(indexPath.row) as NSString

        cell.accessoryType = .None
        if(indexPath.row == selectedOptionIndex)
        {
            cell.accessoryType = .Checkmark
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        selectedOptionIndex = indexPath.row
//        self.currentOption = self.currentOptions.objectAtIndex(selectedOptionIndex) as Option!
        tableView.reloadData()
    }


}
