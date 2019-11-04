//
//  WorkoutsViewController.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 8/31/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit
import CoreData

class WorkoutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    let workoutController = WorkoutController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Workout> = {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: false),
                                        NSSortDescriptor(key: "date", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "isComplete", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error fetching objects: \(error)")
        }
        
        return frc
    }()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        self.tableView.rowHeight = 100.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? WorkoutTableViewCell else { return UITableViewCell() }
        
        cell.workout = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
