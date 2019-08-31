//
//  Workout.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 8/31/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

class Workout: Codable {
    var title: String
    var exercises: String
    var date: Date
    var isCompleted: Bool
    
    init(title: String, exercises: String, date: Date, isCompleted: Bool) {
        self.title = title
        self.exercises = exercises
        self.date = date
        self.isCompleted = isCompleted
    }
}
