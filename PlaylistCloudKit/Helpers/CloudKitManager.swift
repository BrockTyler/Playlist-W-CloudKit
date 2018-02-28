//
//  CloudKitManager.swift
//  PlaylistCloudKit
//
//  Created by brock tyler on 2/28/18.
//  Copyright © 2018 Brock Tyler. All rights reserved.
//

import Foundation
import CloudKit


class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    func saveRecordToCloudKit(record: CKRecord, database: CKDatabase, completion: @escaping (CKRecord?, Error?) -> Void) {
        
        database.save(record, completionHandler: completion)
        
    }
    
    func fetchRecordsOf(type: String,
                        predicate: NSPredicate = NSPredicate(value: true),
                        database: CKDatabase,
                        completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        let query = CKQuery(recordType: type, predicate: predicate)
        
        // putting in nil for inZoneWith will tell it to go to the default.
        database.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    func subscribeToCreationOfRecordsOf(type: String,
                                        database: CKDatabase,
                                        predicate: NSPredicate = NSPredicate(value: true),
                                        withNotificationTitle title: String?,
                                        alertBody: String?,
                                        andSoundName soundName: String?,
                                        completion: @escaping (CKSubscription?, Error?) -> Void) {
        
        // Notification info lets us choose what will be displayed on the banner (if anything at all).
        let subscription = CKQuerySubscription(recordType: type, predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        
        notificationInfo.title = title
        notificationInfo.alertBody = alertBody
        notificationInfo.soundName = soundName
        
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription, completionHandler: completion)
        
    }
    
    // MARK: - User Discoverability
    
    func requestDiscoverabilityAuthorization(completion: @escaping (CKApplicationPermissionStatus, Error?) -> Void) {
        
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (permissionStatus, error) in
            
            // Error will be handled in the model controller.  Want to keep this as generic as possible.
            
            // Make sure the permission status is anything other than granted.  If it is granted, then we don't need to request permission again, so we'll call completion in the else statement.
            guard permissionStatus != .granted else { completion(.granted, error); return }
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability, completionHandler: completion)
        }
        
    }
    
    func fetchUserIdentityWith(email: String, completion: @escaping (CKUserIdentity?, Error?) -> Void) {
        
        CKContainer.default().discoverUserIdentity(withEmailAddress: email, completionHandler: completion)
    }
    
    func fetchUserIdentityWith(phoneNumber: String, completion: @escaping (CKUserIdentity?, Error?) -> Void) {
        
        CKContainer.default().discoverUserIdentity(withPhoneNumber: phoneNumber, completionHandler: completion)
    }
    
}
