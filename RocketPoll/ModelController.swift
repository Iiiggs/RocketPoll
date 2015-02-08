//
//  ModelController.swift
//  SocialPolling
//
//  Created by Igor Kantor on 12/19/14.
//  Copyright (c) 2014 Igor Kantor. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData = NSArray()


    override init() {
        super.init()
        // Create the data model.
        let dateFormatter = NSDateFormatter()
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
        // Return the data view controller for the given index.
//        if (self.pageData.count == 0) || (index >= self.pageData.count) {
//            return nil
//        }

//        // Create a new view controller and pass suitable data.
//        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as DataViewController
//        dataViewController.dataObject = self.pageData[index]
//        return dataViewController

        switch index {
        case 0:
            var vc = storyboard.instantiateViewControllerWithIdentifier("AccountViewController") as AccountViewController
            vc.dataObject = 0
            return vc
        case 1:
            var vc = storyboard.instantiateViewControllerWithIdentifier("MyQuestionsViewController") as MyQuestionsViewController
            vc.dataObject = 1
            return vc
        case 2:
            var vc = storyboard.instantiateViewControllerWithIdentifier("QuestionsListViewController") as QuestionsListViewController
            vc.dataObject = 2
            return vc
        case 3:
            var vc = storyboard.instantiateViewControllerWithIdentifier("SeeResultsViewController") as SeeResultsViewController
            vc.dataObject = 3
            return vc
        default:
            let dataViewController = storyboard.instantiateViewControllerWithIdentifier("PollingViewControllerBase") as PollingViewControllerBase
            dataViewController.dataObject = self.pageData[index]
            return dataViewController
        }
    }

    func indexOfViewController(viewController: PollingViewControllerBase) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        if let dataObject: AnyObject = viewController.dataObject {
            return self.pageData.indexOfObject(dataObject)
        } else {
            return NSNotFound
        }
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        let dataObject: AnyObject = (viewController as PollingViewControllerBase).dataObject!
        var index = dataObject.integerValue!

        if (index == 0){
            return nil
        }


        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let dataObject: AnyObject = (viewController as PollingViewControllerBase).dataObject!
        var index = dataObject.integerValue!

    
        if index == 3 {
            return nil
        }
        
        index++
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageData.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }


}

