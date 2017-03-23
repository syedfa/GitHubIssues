//
//  User+CoreDataProperties.swift
//  
//
//  Created by Fayyazuddin Syed on 2017-03-13.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var userName: String?
    @NSManaged public var id: Int64
    @NSManaged public var issues: NSSet?

}

// MARK: Generated accessors for issues
extension User {

    @objc(addIssuesObject:)
    @NSManaged public func addToIssues(_ value: Issue)

    @objc(removeIssuesObject:)
    @NSManaged public func removeFromIssues(_ value: Issue)

    @objc(addIssues:)
    @NSManaged public func addToIssues(_ values: NSSet)

    @objc(removeIssues:)
    @NSManaged public func removeFromIssues(_ values: NSSet)

}
