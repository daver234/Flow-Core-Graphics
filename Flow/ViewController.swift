//
//  ViewController.swift
//  Flow
//
//  Created by David Rothschild on 7/24/16.
//  Copyright © 2016 Dave Rothschild. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var medalView: MedalView!
    
    //Label outlets
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    var isGraphViewShowing = false
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    //Counter outlets
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.counter)
        checkTotal()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPushButton(button: PushButtonView) {
        if button.isAddButton {
            counterView.counter++
        } else {
            if counterView.counter > 0 {
                counterView.counter--
            }
        }
        counterLabel.text = String(counterView.counter)
        if isGraphViewShowing {
            counterViewTap(nil)
        }
        checkTotal()
    }
    
    func checkTotal() {
        if counterView.counter >= 8 {
            medalView.showMedal(true)
        } else {
            medalView.showMedal(false)
        }
    }
    
    @IBAction func counterViewTap(gesture:UITapGestureRecognizer?) {
        if (isGraphViewShowing) {
            
            //hide Graph
            UIView.transitionFromView(graphView,
                                      toView: counterView,
                                      duration: 1.0,
                                      options: [UIViewAnimationOptions.TransitionFlipFromLeft, UIViewAnimationOptions.ShowHideTransitionViews],
                                      completion:nil)
        } else {
            
            //show Graph
            
            setupGraphDisplay()
            
            UIView.transitionFromView(counterView,
                                      toView: graphView,
                                      duration: 1.0,
                                      options: [UIViewAnimationOptions.TransitionFlipFromRight, UIViewAnimationOptions.ShowHideTransitionViews],
                                      completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    func setupGraphDisplay() {
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 30
        
        //1 - replace last day with today's actual data
        //    graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter
        
        
        //code using the 60 day sample data instead of 7 days
        graphView.graphPoints = getGraphPoints(noOfDays)
        
        
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        
        //3 - calculate average from graphPoints
        let average = graphView.graphPoints.reduce(0, combine: +)
            / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        
        //set up labels
        //day of week labels are set up in storyboard with tags
        //today is last day of the array need to go backwards
        
        //4 - get today's day number
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions,
                                             fromDate: NSDate())
        var weekday = components.weekday
        
        let days = ["S", "S", "M", "T", "W", "T", "F"]
        
        //5 - set up the day name labels with correct day
        for i in Array((1...days.count).reverse()) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                labelView.text = days[weekday--]
                if weekday < 0 {
                    weekday = days.count - 1
                }
            }
        }
    }
    
    //extract data from dataArray
    func getGraphPoints(noOfDays: Int) -> [Int]{
        
        //array of tuples
        //latest date is first in array
        var dataArray:[(NSDate, Int)] = sampleData
        
        //split array to get noOfDays - 1 entries (today will be an extra entry)
        //Note on option + click that newArray is a Slice<(NSDate, Int)>
        //Slices do not have all the methods that Arrays do (eg .map)
        
        let splitIndex = min(dataArray.count, noOfDays-1)
        
        var newArray = dataArray[0..<splitIndex]
        newArray.insert((NSDate(), counterView.counter), atIndex: newArray.startIndex)
        
        //sort into ascending order for graph
        let ascendingOrder = { (date1: (NSDate, Int), date2: (NSDate, Int)) -> Bool in
            return date1.0.compare(date2.0) == .OrderedAscending }
        let sortedDataArray = newArray.sort(ascendingOrder)
        
        //extract the points into an array - don't need dates at this time
        return sortedDataArray.map { $1 }
    }
    
}


