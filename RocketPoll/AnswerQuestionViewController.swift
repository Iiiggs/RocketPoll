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
    var options: [NSString] = []

    var selectedOptionIndex: Int = -1


    var currentQuestion: Question?
    var currentOptions: NSOrderedSet?
    var currentOption: Option?

    override func viewDidLoad() {
        super.viewDidLoad()

        displayLastQuestion()
    }

    func displayLastQuestion(){
        let appDelegate = UIApplication.sharedApplication().delegate as PollingAppDelegate
        let managedContext = appDelegate.managedObjectContext!

        let fetchRequest = NSFetchRequest(entityName:"Question")
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [Question]

        if let results = fetchedResults {
            if results.count > 0
            {
                self.currentQuestion = results.last! as Question!
                self.questionLabel.text = self.currentQuestion!.text

                self.currentOptions = self.currentQuestion!.valueForKey("options") as NSOrderedSet!

                self.selectedOptionIndex = -1
                self.options = []
                self.currentOptions!.enumerateObjectsUsingBlock({ (option, index, stop) -> Void in
                    var managedOption = (option as Option)
                    self.options.append(managedOption.text)
                })

                self.tableView.reloadData()
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

    @IBAction func click(sender: AnyObject) {

        if(currentOption != nil && currentOptions != nil)
        {

            let appDelegate = UIApplication.sharedApplication().delegate as PollingAppDelegate
            let managedContext = appDelegate.managedObjectContext!
            // create a coredata entry for a question response

            let response =  NSEntityDescription.insertNewObjectForEntityForName("Answer",
                inManagedObjectContext:
                managedContext) as Answer


                response.question = currentQuestion!
                response.option = currentOption!

            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }

        showSwipeRight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return options.count
    }

    override func viewWillAppear(animated: Bool) {
        displayLastQuestion()
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell

        cell.backgroundColor = UIColor.clearColor()

        cell.textLabel!.text = self.options[indexPath.row]

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
        self.currentOption = self.currentOptions?.objectAtIndex(selectedOptionIndex) as Option!
        tableView.reloadData()
    }


}
