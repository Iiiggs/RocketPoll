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
        backendQuestion["friends"] = friends
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

                var push = PFPush()
                push.setChannel("questions_to_\(friends.first!)")
                push.setMessage("You have a new question from \(PFUser.currentUser().username)")
                push.sendPushInBackgroundWithBlock(nil)
            }
        }
    }

    // Query questions sent to me
    func getQuestionsWithBlock(block: QuestionsResultBlock){
        var questions: [Question]! = []

        var query = PFQuery(className:"Question")

        let facebookId = PFUser.currentUser().objectForKey("facebookUser").objectForKey("id") as String

        query.whereKey("friends", equalTo: facebookId)

        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock{ (backendQuestions: [AnyObject]!, error) -> Void in
            if error == nil {
                for backendQuestion in backendQuestions as [PFObject]!{
                    // <mapperCode>
                    var mutable_options = NSMutableOrderedSet()
                    for option in backendQuestion.objectForKey("options") as NSArray{
                        mutable_options.addObject(option as NSString)
                    }

                    var question = Question(
                        text: backendQuestion.objectForKey("text") as NSString,
                        options: mutable_options,
                        askedBy: backendQuestion.objectForKey("createdBy") as PFUser//.objectForKey("facebookUser").objectForKey("first_name")  as String
                    )
                    // </mapperCode>

                    questions.append(question)
                }

                block(questions, nil)
            }
            else {
                println("Error getting questions in background \(error)")
                block(nil, error)
            }
        }
    }
    // Answer question
    func answerQuestion(answer: Answer){
        var backendAnswer = PFObject(className:"Answer")
        backendAnswer["question"] = answer.question // can we get away with just submitting the question?
        backendAnswer["option"] = answer.option
        backendAnswer["createdBy"] = PFUser.currentUser()
        backendAnswer.saveInBackgroundWithBlock(nil)
    }
    // Query aggregate responses
    func getAnswersWithBlock(block: AnswersResultBlock){
        var query = PFQuery(className: "Answer")
        // filter to my questions/specific question
        query.findObjectsInBackgroundWithBlock { (backendAnswers: [AnyObject]!, error) -> Void in

            if error == nil{
                var answers = [Answer]()
                for backendAnswer in backendAnswers as [PFObject]{
                    answers.append(
                        Answer(
                            question: backendAnswer.objectForKey("question") as String,
                            option:backendAnswer.objectForKey("option") as String))
                }
                block(answers, nil)
            }
            else{
                block(nil, error)
            }
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
                    }
                }

//                for answer in answers {
//                    if let count = dict[answer.question]![answer.option] as? Int {
//                        dict[answer.question][answer.option] = count + 1
//                    }
//                    else{
//                        dict[answer.question][answer.option] = 1
//                    }
//                }

                println("Done counting \(dict)")

                block(dict, nil)
            }
            else {
                block(nil, error)
            }
        }



//        block(["Option 1": "1", "Option 2": "3", "Option 3": "2"], nil)
    }
}