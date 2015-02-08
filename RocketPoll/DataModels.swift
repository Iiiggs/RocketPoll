//
//  Question.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/20/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import Foundation
import CoreData

class Answer : PFObject, PFSubclassing{

    var selection: String {
        get {
            return objectForKey("selection") as String
        }
        set {
            setObject(newValue, forKey: "selection")
        }
    }

    var question: Question {
        get {
            return objectForKey("question") as Question
        }
        set {
            setObject(newValue, forKey: "question")
        }
    }


//    var question_text: String {
//        get {
//            return objectForKey("question_text") as String
//        }
//        set {
//            setObject(newValue, forKey: "question_text")
//        }
//    }

//    var questionObject: Question {
//        get{
//            return objectForKey("question") as Question
//        }
//        set {
//            setObject(newValue, forKey: "question")
//        }
//    }

    var answeredBy: PFUser {
        get {
            return objectForKey("answeredBy") as PFUser
        }
        set {
            setObject(newValue, forKey: "answeredBy")
        }
    }

//    var askedBy: PFUser? {
//        get {
//            return objectForKey("askedBy") as? PFUser
//        }
//        set {
//            setObject(newValue, forKey: "askedBy")
//        }
//    }


//    var askedBy: PFUser {
//        get {
//            return objectForKey("askedBy") as PFUser
//        }
//        set {
//            setObject(newValue, forKey: "askedBy")
//        }
//    }

    class func parseClassName() -> String! {
        return "Answer"
    }

    override class func load(){
        self.registerSubclass()
    }

}

class Option {
    var text: String

    init(text: String){
        self.text = text
    }

}

class Question: PFObject, PFSubclassing{

    var text: String {
        get {
            return objectForKey("text") as String
        }
        set {
            setObject(newValue, forKey: "text")
        }
    }

    var options: Array<String> {
        get {
            return objectForKey("options") as Array<String>
        }
        set {
            setObject(newValue, forKey: "options")
        }
    }

    var askedOf: Array<PFUser> {
        get {
            return objectForKey("askedOf") as Array<PFUser>
        }
        set {
            setObject(newValue, forKey: "askedOf")
        }
    }

    var askedBy: PFUser {
        get {
            return objectForKey("askedBy") as PFUser
        }
        set {
            setObject(newValue, forKey: "askedBy")
        }
    }

    var answers: [Answer]? {
        get {
            return objectForKey("answers") as? [Answer]
        }
        set {
            setObject(newValue, forKey: "answers")
        }
    }

    var answeredBy: [PFUser]? {
        get {
            return objectForKey("answeredBy") as? [PFUser]
        }
        set {
            setObject(newValue, forKey: "answeredBy")
        }
    }


    class func parseClassName() -> String! {
        return "Question"
    }

    override class func load(){
        self.registerSubclass()
    }
}


