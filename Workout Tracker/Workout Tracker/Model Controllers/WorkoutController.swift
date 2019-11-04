//
//  Workout Controller.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 8/31/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class WorkoutController {
    
    init() {
        fetchItemsFromServer()
    }
    
    let baseURL = URL(string: "https://workouttracker-21a4e.firebaseio.com/")!
    let userToken = ""
    
    func put(workout: Workout, completion: @escaping () -> Void = { }) {
        
        let identifier = workout.identifier?.uuidString ?? UUID().uuidString
        workout.identifier = UUID(uuidString: identifier)
        
        let requestURL = baseURL.appendingPathComponent(userToken)
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let workoutRepresentation = workout.rep else {
            NSLog("Workout representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(workoutRepresentation)
        } catch {
            NSLog("Error encoding workout representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            
            if let error = error {
                NSLog("Error PUTting workout: \(error)")
                completion()
                return
            }
            completion()
            }.resume()
    }
    
    func fetchItemsFromServer(completion: @escaping () -> Void = { }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion()
            }
            
            guard let data = data else {
                NSLog("No data returned from data entries")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let workoutRepresentations = try decoder.decode([String: WorkoutRepresentation].self, from: data).map({ $0.value })
                
                self.updateWorkouts(with: workoutRepresentations)
                self.save()
                
            } catch {
                NSLog("Error decoding: \(error)")
            }
            
            }.resume()
    }
    
    func fetchSingleWorkoutFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Workout? {
        var tempWorkout: Workout?
        
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "identifier", cacheName: nil)
        
        do {
            try frc.performFetch()
            
            tempWorkout = frc.object(at: IndexPath(row: 0, section: 0))
        } catch {
            NSLog("Error performing fetch for frc: \(error)")
        }
        
        return tempWorkout
    }
    
    func deleteWorkoutFromServer(workout: Workout, completion: @escaping () -> Void = { }) {
        
        let identifier = workout.identifier ?? UUID()
        workout.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        guard let workoutRepresentation = workout.rep else {
            NSLog("Workout representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(workoutRepresentation)
        } catch {
            NSLog("Error encoding workout representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            
            if let error = error {
                NSLog("Error deleting workout: \(error)")
                completion()
                return
            }
            completion()
            }.resume()
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
    
    func updateWorkouts(with workoutRepresentations: [WorkoutRepresentation]) {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.performAndWait {
            for i in 0...workoutRepresentations.count - 1 {
                if let workout = self.fetchSingleWorkoutFromPersistentStore(identifier: workoutRepresentations[i].identifier.uuidString, context: CoreDataStack.shared.mainContext) {
                    if workoutRepresentations[i] != workout {
                        self.update(workout: workout, workoutRep: workoutRepresentations[i])
                    }
                } else {
                    self.createWorkoutFromRep(with: workoutRepresentations[i])
                }
            }
        }
    }
    
    @discardableResult
    func createWorkout(with name: String, exercises: [Exercise], date: Date, isComplete: Bool = false) -> Workout {
        let workout = Workout(name: name, exercises: exercises, date: date, isComplete: isComplete)
        save()
        put(workout: workout)
        return workout
    }
    
    @discardableResult
    func createWorkoutFromRep(with workoutRep: WorkoutRepresentation) -> Workout {
        var exercises = [Exercise]()
        for exer in workoutRep.exercises {
            exercises.append(Exercise(rep: exer))
        }
        return createWorkout(with: workoutRep.name, exercises: exercises, date: workoutRep.date, isComplete: workoutRep.isComplete)
    }
    
    func update(workout: Workout, workoutRep: WorkoutRepresentation) {
        workout.name = workoutRep.name
        workout.exercises = NSOrderedSet(object: workoutRep.exercises)
        workout.date = workoutRep.date
        workout.isComplete = workoutRep.isComplete
        workout.identifier = workoutRep.identifier
    }
    
    func updateWorkout(workout: Workout, with name: String, exersizes: [Exercise], date: Date) {
        workout.name = name
        workout.exercises = NSOrderedSet(object: exersizes)
        workout.date = date
        
        save()
        put(workout: workout)
    }
    
    func deleteWorkout(workout: Workout) {
        CoreDataStack.shared.mainContext.delete(workout)
        deleteWorkoutFromServer(workout: workout)
        save()
    }
}
