//
//  EditQuestionViewController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit
import CoreData


class CreateQuestionViewController: PollingViewControllerBase, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "answerOption"

    var text: NSString = ""
    var options: [NSString] = []

    var optionTextFields: NSMutableSet = NSMutableSet()

    @IBOutlet weak var questionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad() 

        // Do any additional setup after loading the view.
        self.optionTextFields = NSMutableSet()

        self.displayLastQuestion()
    }

    @IBAction func click(sender: AnyObject){
        self.text = questionTextField.text

        // save to shared storage
        saveOptions()

        // show friends list
        showFriendsList()

        // for now, go to next page
        showSwipeRight()        
    }

    func showFriendsList(){
        
    }

    func saveOptions(){
        let appDelegate = UIApplication.sharedApplication().delegate as PollingAppDelegate
        let managedContext = appDelegate.managedObjectContext!

        let question =   NSEntityDescription.insertNewObjectForEntityForName("Question",
            inManagedObjectContext:
            managedContext) as Question

        question.text = self.text

        var optionsSet = question.options.mutableCopy() as NSMutableOrderedSet

        for optionTextField in self.optionTextFields {
            var option = NSEntityDescription.insertNewObjectForEntityForName("Option",
                inManagedObjectContext:
                managedContext) as Option
            option.text = optionTextField.text
            optionsSet.addObject(option)
        }
        question.options = optionsSet.copy() as NSOrderedSet

        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return options.count + 1
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as AnswerOptionTableViewCell

        cell.backgroundColor = UIColor.clearColor()

        var textField = cell.viewWithTag(10) as UITextField

        var label = cell.viewWithTag(20) as UILabel

        if(indexPath.row == options.count)
        {
            textField.hidden = true
            label.text = "+"
        }
        else
        {
            textField.hidden = false
            label.hidden = true
            textField.delegate = self
            textField.text = options[indexPath.row]
            optionTextFields.addObject(textField)
        }


        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        if(indexPath.row == options.count) // tapped +
        {
            options = []
            for optionTextField in self.optionTextFields {
                options.append(optionTextField.text)
            }

            options.append("")
            tableView.reloadData()
        }
        else
        {

        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
                let currentQuestion = results.last! as Question!

                println(currentQuestion!.text)
                self.questionTextField.text = currentQuestion!.text

                let currentOptions = currentQuestion!.valueForKey("options") as NSOrderedSet!

                self.options = []
                currentOptions!.enumerateObjectsUsingBlock({ (option, index, stop) -> Void in
                    var managedOption = (option as Option)
                    self.options.append(managedOption.text)
                })

                self.tableView.reloadData()
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

    override func viewWillAppear(animated: Bool) {
        displayLastQuestion()
    }

}
