//
//  PostEntity+CoreDataProperties.swift
//  Test_Task
//
//  Created by Александр Андреев on 30.03.2025.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var userId: Int64
    @NSManaged public var avatar: String?
    @NSManaged public var name: String?
    @NSManaged public var isLiked: Bool

}

extension PostEntity : Identifiable {

}
