//
//  DataController.swift
//  RocketPoll
//
//  Created by Igor Kantor on 1/10/15.
//
//

import Foundation


typealias AnswersResultBlock = ([Answer]!, NSError!) -> Void
typealias AnswersCountResultBlock = (NSDictionary!, NSError!) -> Void
typealias QuestionsResultBlock = ([Question]!, NSError!) -> Void
typealias UsersResultBlock = ([PFUser]!, NSError!) -> Void


public class DataController{
// This class should be accesssible from any view controller
    class var sharedInstance : DataController {
        struct Static {
            static let instance : DataController = DataController()
        }
        return Static.instance
    }

// A user should be able to:
    // Trigger question to friends
    func askQuestion(text: NSString, options:[AnyObject], friends:[AnyObject]){
        let backendQuestion = PFObject(className:"Question")
        backendQuestion["text"] = text
        backendQuestion["options"] = options
        backendQuestion["askedOf"] = friends
        backendQuestion["createdBy"] = PFUser.currentUser()
        backendQuestion.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {

                // save to users asked questions list
                var questions = PFUser.currentUser().objectForKey("questions") as! NSMutableArray?

                if questions == nil {
                    questions = NSMutableArray()
                }
                questions!.addObject(backendQuestion)

                PFUser.currentUser().setObject(questions, forKey: "questions")
                PFUser.currentUser().saveInBackgroundWithBlock(nil)

                for friend in friends {
                    let push = PFPush()
                    push.setChannel("questions_to_\(friend.objectId)")
                    push.setMessage("You have a new question from \(PFUser.currentUser().username)")
                    push.sendPushInBackgroundWithBlock(nil)
                }
            }
        }
    }


    func getCurrentUserFriendsWithBlock(block: UsersResultBlock){
        let query = PFUser.query()

        // filter to triends only

        query.findObjectsInBackgroundWithBlock { (users, error) -> Void in
            block(users as? [PFUser], error)
        }


    }
}