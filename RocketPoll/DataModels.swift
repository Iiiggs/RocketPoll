//
//  Question.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/20/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import Foundation
import CoreData

class Answer {
    var option: Option
    var question: Question

    init(question: Question, option: Option){
        self.question = question
        self.option = option
    }

    init(question: String, option: String){
        self.question = Question(text: question, options: NSOrderedSet(), askedBy: PFUser())
        self.option = Option(text: option)
    }
}

class Option {
    var text: String

    init(text: String){
        self.text = text
    }

}

class Question {
    var text: String
    var options: NSOrderedSet
    var askedBy: PFUser

    init(text: String, options: NSOrderedSet, askedBy: PFUser){
        self.text = text
        self.options = options
        self.askedBy = askedBy
    }
}


