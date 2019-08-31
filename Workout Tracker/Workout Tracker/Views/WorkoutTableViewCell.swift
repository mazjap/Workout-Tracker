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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exercisesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private func updateViews() {
        if let workout = workout {
            titleLabel.text = workout.title
            exercisesLabel.text = workout.exercises
            dateLabel.text = dateFormatter.string(from: workout.date)
        }
    }
    
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
