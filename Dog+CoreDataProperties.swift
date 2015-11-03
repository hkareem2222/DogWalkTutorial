//
//  Dog+CoreDataProperties.swift
//  Dog Walk
//
//  Created by Husein Kareem on 11/3/15.
//  Copyright © 2015 Razeware. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Dog {

    @NSManaged var name: String?
    @NSManaged var walks: NSOrderedSet?

}
