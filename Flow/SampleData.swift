//
//  ViewController.swift
//  Flow
//
//  Created by David Rothschild on 7/24/16.
//  Copyright © 2016 Dave Rothschild. All rights reserved.
//

import Foundation

let sampleData = setupSampleData()

func setupSampleData() -> [(NSDate, Int)] {
  
  //set up weighting for sample data
  //glasses drunk are never less than two, and most likely 3,4, 5
  let noOfGlasses = [2, 3, 4, 5, 6, 7, 8, 9, 10, 3, 4, 5, 6, 7, 8, 3, 4, 5]
  
  var dataArray:[(NSDate, Int)] = []
  
  //Set up 60 days worth of sample data
  //Sets up 60 days prior to this one
  //with random glasses drunk (0 to 8)
  
  let date = NSDate()
  let calendar = NSCalendar.currentCalendar()
  let componentOptions:NSCalendarUnit = [.Day, .Month, .Year]
  let components = calendar.components(componentOptions, fromDate: date)
  
  for i in 1...60 {
    components.day--
    let date = calendar.dateFromComponents(components)!
    let glassesDrunk = noOfGlasses[random() % (noOfGlasses.count - 1)]
    let data = (date, glassesDrunk)
    dataArray.append(data)
  }
  return dataArray
}
