//
//  Playlist.swift
//  PlaylistCloudKit
//
//  Created by brock tyler on 2/28/18.
//  Copyright © 2018 Brock Tyler. All rights reserved.
//

import Foundation
import CloudKit

class Playlist {
    
    static let typeKey = "Playlist"
    private let nameKey = "name"
    
    let name: String
    var songs: [Song]
    var cloudKitRecordId: CKRecordID?
    
    init(name: String, songs: [Song] = []) {
        self.name = name
        self.songs = songs
    }
    
    init?(cloudKitRecord: CKRecord) {
        
        guard let name = cloudKitRecord[nameKey] as? String else { return nil }
        
        self.name = name
        self.songs = []
        self.cloudKitRecordId = cloudKitRecord.recordID
    }
    
    var cloudKitRecord: CKRecord {
        
        let recordID = cloudKitRecordId ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: Playlist.typeKey, recordID: recordID)
        
        record.setValue(name, forKey: nameKey)
        
        return record
        
    }
}
