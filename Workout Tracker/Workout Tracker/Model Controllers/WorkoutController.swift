//
//  Workout Controller.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 8/31/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

class WorkoutController {
    var workouts: [Workout] = []
    var complete: [Workout] = []
    var uncomplete: [Workout] = []
    
    init() {
        complete = workouts.filter { $0.isCompleted == true }
        uncomplete = workouts.filter { $0.isCompleted == false }
    }
    
    func addWorkout(_ title: String, _ exercises: String, _ date: Date, _ isCompleted: Bool) {
        workouts.append(Workout(title: title, exercises: exercises, date: date, isCompleted: isCompleted))
        saveToPersistentStore()
    }
    
    func removeWorkout(workout: Workout) -> Bool {
        let index = indexOf(workout)
        if index != -1 {
            workouts.remove(at: index)
            return true
        }
        return false
    }
    
    private func indexOf(_ workout: Workout) -> Int {
        for i in 0...workouts.count - 1 {
            if workout.title == workouts[i].title &&
               workout.exercises == workouts[i].exercises &&
               workout.date == workouts[i].date &&
               workout.isCompleted == workouts[i].isCompleted {
                return i
            }
        }
        return -1
    }
    
    private var persistentFileURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documents.appendingPathComponent("workouts.plist")
    }
    
    func saveToPersistentStore() {
        guard let url = persistentFileURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(workouts)
            try data.write(to: url)
        } catch {
            print("Error saving stars data: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        let fileManager = FileManager.default
        guard let url = persistentFileURL, fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            workouts = try decoder.decode([Workout].self, from: data)
        } catch {
            print("Error loading stars data: \(error)")
        }
    }
}
