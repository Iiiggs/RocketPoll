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
        var backendQuestion = PFObject(className:"Question")
        backendQuestion["text"] = text
        backendQuestion["options"] = options
        backendQuestion["askedOf"] = friends
        backendQuestion["createdBy"] = PFUser.currentUser()
        backendQuestion.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {

                // save to users asked questions list
                var questions = PFUser.currentUser().objectForKey("questions") as NSMutableArray?

                if questions == nil {
                    questions = NSMutableArray()
                }
                questions!.addObject(backendQuestion)

                PFUser.currentUser().setObject(questions, forKey: "questions")
                PFUser.currentUser().saveInBackgroundWithBlock(nil)

                for friend in friends {
                    var push = PFPush()
                    push.setChannel("questions_to_\(friend.objectId)")
                    push.setMessage("You have a new question from \(PFUser.currentUser().username)")
                    push.sendPushInBackgroundWithBlock(nil)
                }
            }
        }
    }


    // Query aggregate responses
    func getAnswersWithBlock(block: AnswersResultBlock){
        var query = PFQuery(className: "Answer")
        // filter to my questions/specific question
        query.findObjectsInBackgroundWithBlock { (answers: [AnyObject]!, error) -> Void in
                block(answers as [Answer], error)
        }
    }

    //            ["Where should I eat tonight?":                          ["McDonalds": 1,
    //                "Burger King": 3,
    //                "Fugo De Chao": 12,
    //                "Thai Place": 3,
    //                "Spookey Sushi": 0,
    //                "Yobagoya": 1,
    //                "C.B. Potts": 4],
    //            "Should we go skiiing this weekend?" :
    //                ["Yes": 3,
    //                "No": 0,
    //                "Maybe": 2]]


    func countAnswersWithBlock(block: AnswersCountResultBlock){

        getAnswersWithBlock { (answers, error) -> Void in
            if error == nil {
                // group by the answers and make a dict
                var dict =  Dictionary<String, Dictionary<String, Int>>()

                // work on filling this dict!!!
                for answer in answers{
                    if dict[answer.question] == nil {
                        var qdict = Dictionary<String, Int>()
                        qdict[answer.option] = 1
                        dict[answer.question] = qdict
                    }
                    else {
                        var qdict = dict[answer.question]!
                        if qdict[answer.option] != nil{
                            let count = qdict[answer.option]! + 1
                            qdict[answer.option] = count
                        }
                        else {
                            qdict[answer.option] = 1
                        }
                        dict[answer.question] = qdict
                    }
                }

                block(dict, nil)
            }
            else {
                block(nil, error)
            }
        }
    }

    func getCurrentUserFriendsWithBlock(block: UsersResultBlock){
        let query = PFUser.query()

        // filter to triends only

        query.findObjectsInBackgroundWithBlock { (users, error) -> Void in
            println(users)
            block(users as? [PFUser], error)
        }


    }
}