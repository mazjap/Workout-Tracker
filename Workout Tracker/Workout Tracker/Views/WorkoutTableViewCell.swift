//
//  WorkoutTableViewCell.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 8/31/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    var workout: Workout? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var exercisesLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private func updateViews() {
        if let workout = workout {
            titleLabel.text = workout.name
            exercisesLabel.text = getWorkouts(exercises: workout.exercises ?? NSOrderedSet())
            dateLabel.text = dateFormatter.string(from: workout.date ?? Date())
        }
    }
    
    private func getWorkouts(exercises: NSOrderedSet) -> String {
        var str = ""
        guard let exercises = Array(exercises) as? [Exercise] else { return str }
        for index in 0..<exercises.count {
            if index == exercises.count - 1 {
                str += exercises[index].name ?? ""
            } else {
                str += "\(String(describing: exercises[index].name)) | "
            }
        }
        return str
    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
