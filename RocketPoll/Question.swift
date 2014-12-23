//
//  Question.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/20/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import Foundation
import CoreData

// add models for question, answer and result
// add alamofire support
// 


class Answer: NSManagedObject {
    @NSManaged var option: Option
    @NSManaged var question: Question
}


class Option: NSManagedObject {
    @NSManaged var text: String
    @NSManaged var question: Question
}


class Question: NSManagedObject {
    @NSManaged var text: String
    @NSManaged var options: NSOrderedSet

}