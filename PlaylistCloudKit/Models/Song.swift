//
//  Song.swift
//  PlaylistCloudKit
//
//  Created by brock tyler on 2/28/18.
//  Copyright © 2018 Brock Tyler. All rights reserved.
//

import Foundation
import CloudKit

class Song {
    
    static let typeKey = "Song"
    private let titleKey = "title"
    private let artistKey = "artist"
    private let playlistReferenceKey = "playlistReference"
    
    let title: String
    let artist: String
    
    weak var playlist: Playlist?
    
    var cloudKitRecordID: CKRecordID? // same as unique identifier
    
    init(title: String, artist: String, playlist: Playlist?) {
        self.title = title
        self.artist = artist
        self.playlist = playlist
    }
    
    init?(cloudKitRecord: CKRecord) {
        
        guard let title = cloudKitRecord[titleKey] as? String,
            let artist = cloudKitRecord[artistKey] as? String else { return nil }
        
        self.title = title
        self.artist = artist
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
    
    var cloudKitRecord: CKRecord {
        
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: Song.typeKey, recordID: recordID)
        
        record.setValue(title, forKey: titleKey)
        record.setValue(artist, forKey: artistKey)
        
        if let playlist = playlist,
            let playlistRecordID = playlist.cloudKitRecordId {
            
            let playlistReference = CKReference(recordID: playlistRecordID, action: .deleteSelf)
            
            record.setValue(playlistReference, forKey: playlistReferenceKey)
        }
        
        return record
    }
}
