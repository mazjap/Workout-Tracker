//
//  WorkoutRepresentation.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

struct WorkoutRepresentation: Codable, Equatable {
    var name: String
    var exercises: [ExerciseRepresentation]
    var date: Date
    var created: Date
    var isComplete: Bool
    var identifier: UUID
    
    static func == (lhs: WorkoutRepresentation, rhs: Workout) -> Bool {
        guard let exer = rhs.exercises, let exerArray = Array(exer) as? [Exercise] else { return false }
        let count = exerArray.count > lhs.exercises.count ? exerArray.count : lhs.exercises.count
        var areArraysEqual = true
        for i in 0..<count where !(lhs.exercises[i] == exerArray[i]) {
            areArraysEqual = false
        }
        return lhs.name == rhs.name &&
            areArraysEqual &&
            lhs.date == rhs.date &&
            lhs.created == rhs.created &&
            lhs.isComplete == rhs.isComplete &&
            lhs.identifier == rhs.identifier
    }
    
    static func != (lhs: WorkoutRepresentation, rhs: Workout) -> Bool {
        return !(lhs == rhs) ? true : false
    }
}

struct ExerciseRepresentation: Codable, Equatable {
    var name: String
    var sets: Int16
    var reps: Int16
    
    static func == (lhs: ExerciseRepresentation, rhs: Exercise) -> Bool {
        return lhs.name == rhs.name &&
            lhs.sets == rhs.sets &&
            lhs.reps == rhs.reps
    }
}
