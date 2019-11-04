//
//  Workout.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 8/31/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

extension Workout {
    
    var rep: WorkoutRepresentation? {
        guard let name = name, let exercizesSet = exercises,
            let exercises = Array(exercizesSet) as? [Exercise], let date = date,
            let created = created, let identifier = identifier else { return nil }
        var exersizeReps: [ExerciseRepresentation] = []
        for exersize in exercises {
            if let rep = exersize.rep {
                exersizeReps.append(rep)
            }
        }
        
        return WorkoutRepresentation(name: name, exercises: exersizeReps, date: date, created: created, isComplete: isComplete, identifier: identifier)
    }
    
    convenience init(name: String, exercises: [Exercise], date: Date, isComplete: Bool, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.name = name
        self.exercises = NSOrderedSet(object: exercises)
        self.date = date
        self.created = Date()
        self.isComplete = isComplete
    }
    
    convenience init(rep: WorkoutRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.name = rep.name
        self.exercises = NSOrderedSet(object: rep.exercises)
        self.date = rep.date
        self.created = rep.created
        self.isComplete = rep.isComplete
    }
}
