//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Nicolás Cadena on 17/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

enum EntityError: Error {
	case entityNameNotFound
}

@objc(ManagedCache)
internal class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet

	static func findCache(in context: NSManagedObjectContext) throws -> ManagedCache? {
		guard let entityName = entity().name else { throw EntityError.entityNameNotFound }
		let request = NSFetchRequest<ManagedCache>(entityName: entityName)
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}

	static func uniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
		try findCache(in: context).map(context.delete)
		return ManagedCache(context: context)
	}

	var localFeed: [LocalFeedImage] {
		return feed.compactMap { ($0 as? ManagedFeedImage)?.localFeedImage }
	}
}
