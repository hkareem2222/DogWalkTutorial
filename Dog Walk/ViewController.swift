//
//  ViewController.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/17/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    var managedContext: NSManagedObjectContext!
  lazy var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .MediumStyle
    return formatter
  }()
  
  @IBOutlet var tableView: UITableView!
    var currentDog: Dog!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    tableView.registerClass(UITableViewCell.self,
      forCellReuseIdentifier: "Cell")
    
    let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: self.managedContext)
    let dogName = "Fido"
    let dogFetch = NSFetchRequest(entityName: "Dog")
    dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
    
    do {
        let results = try managedContext.executeFetchRequest(dogFetch) as! [Dog]
        if results.count > 0 {
            self.currentDog = results.first
        } else {
            self.currentDog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: self.managedContext)
            self.currentDog.name = dogName
            try managedContext.save()
        }
    } catch let error as NSError {
        print("Error: \(error) " + "description \(error.localizedDescription)")
    }
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      
      return self.currentDog.walks!.count
  }
  
  func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
      return "List of Walks"
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell =
      tableView.dequeueReusableCellWithIdentifier("Cell",
        forIndexPath: indexPath) as UITableViewCell
      
        let walk = self.currentDog.walks![indexPath.row] as! Walk
        cell.textLabel!.text = self.dateFormatter.stringFromDate(walk.date!)
      
      return cell
  }
  
  @IBAction func add(sender: AnyObject) {
    let walkEntity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: self.managedContext)
    let walk = Walk(entity: walkEntity!, insertIntoManagedObjectContext: self.managedContext)
    walk.date = NSDate()
    
    let walks = self.currentDog.walks!.mutableCopy() as! NSMutableOrderedSet
    walks.addObject(walk)
    self.currentDog.walks = walks.copy() as? NSOrderedSet
    
    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save: \(error)")
    }
    
    tableView.reloadData()
  }
}

