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
    var option: String {
        get {
            return objectForKey("option") as String
        }
        set {
            setObject(newValue, forKey: "option")
        }
    }

    var question: String {
        get {
            return objectForKey("question") as String
        }
        set {
            setObject(newValue, forKey: "question")
        }
    }

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

    class func parseClassName() -> String! {
        return "Question"
    }

    override class func load(){
        self.registerSubclass()
    }


//    var text: String
//    var options: NSOrderedSet
//    var askedBy: PFUser
//
//    init(text: String, options: NSOrderedSet, askedBy: PFUser){
//        self.text = text
//        self.options = options
//        self.askedBy = askedBy
//    }
}


