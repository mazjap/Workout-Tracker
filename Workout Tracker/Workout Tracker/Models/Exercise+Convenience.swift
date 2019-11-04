//
//  Exercise+Convenience.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 11/4/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

extension Exercise {
    
    var rep: ExerciseRepresentation? {
        guard let name = name else { return nil }
        return ExerciseRepresentation(name: name, sets: sets, reps: reps)
    }
    
    convenience init(name: String, sets: Int16, reps: Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.name = name
        self.reps = reps
        self.sets = sets
    }
    
    convenience init(rep: ExerciseRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.name = rep.name
        self.reps = rep.reps
        self.sets = rep.sets
    }
}
