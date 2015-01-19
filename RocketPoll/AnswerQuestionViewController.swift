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
//    var options: [NSString] = []

    var selectedOptionIndex: Int = -1


    var currentQuestion: Question?
    var currentOptions = NSOrderedSet()
    var currentOption: Option?

    override func viewDidLoad() {
        super.viewDidLoad()


        getQuestionFromParse()
    }

    func getQuestionFromParse	()
    {
        // get the  questions
        DataController.sharedInstance.getQuestionsWithBlock { (questions, error) -> Void in
            if (questions != nil && questions.count > 0){

                // grab the last one
                let lastquestion = questions.last!

                // show the question
                self.questionLabel.text = lastquestion.text
                self.currentOptions = lastquestion.options
                println("\(self.questionLabel.text) \(self.currentOptions)")
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.questionLabel.setNeedsDisplay()
                    self.tableView.reloadData()
                    println("resetting display in background")
                })
            }
        }

    }

    @IBAction func click(sender: AnyObject) {

//        if(currentOption != nil && currentOptions != nil)
//        {
//                response.question = currentQuestion!
//                response.option = currentOption!
//
//        }

        showSwipeRight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        println(self.currentOptions.count)
        return self.currentOptions.count
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

        cell.textLabel!.text = self.currentOptions[indexPath.row] as NSString

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
