//
//  PlaylistController.swift
//  PlaylistCloudKit
//
//  Created by brock tyler on 2/28/18.
//  Copyright © 2018 Brock Tyler. All rights reserved.
//

import Foundation
import CloudKit


class PlaylistController {
    
    static let shared = PlaylistController()
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    var playlists: [Playlist] = []
    
    func createPlaylistWith(name: String, completion: @escaping () -> Void) {
        
        let playlist = Playlist(name: name)
        
        CloudKitManager.shared.saveRecordToCloudKit(record: playlist.cloudKitRecord, database: privateDB) { (record, error) in
            
            if let error = error {
                print("Error saving playlist record to CloudKit: \(error.localizedDescription)")
            } else {
                playlist.cloudKitRecordId = record?.recordID
                self.playlists.append(playlist)
            }
            
            completion()
        }
    }
    
    func fetchAllPlaylistsFromCloudKit(completion: @escaping () -> Void) {
        
        CloudKitManager.shared.fetchRecordsOf(type: Playlist.typeKey, database: privateDB) { (records, error) in
            
            if let error = error {
                print("Error fetching playlists from CloudKit: \(error.localizedDescription)")
            }
            
            guard let records = records else { completion(); return }
            
            let playlists = records.flatMap({ Playlist(cloudKitRecord: $0) })
            
            // Need to make sure playlists finish fetching their songs before successive code is executed, we use DispatchGroup():
            let group = DispatchGroup()
            
            for playlist in playlists {
                
                group.enter()
                self.fetchSongsFor(playlist: playlist, completion: {
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                
                // The code in this closure will run ONLY when all things have left the group.
                self.playlists = playlists
                completion()
            })
        }
    }
    
    
    func fetchSongsFor(playlist: Playlist, completion: @escaping () -> Void) {
        
        guard let playlistRecordID = playlist.cloudKitRecordId else { completion(); return }
        
        let playlistReference = CKReference(recordID: playlistRecordID, action: .deleteSelf)
        
        let predicate = NSPredicate(format: "playlistReferenceKey == %@", playlistReference)
        
        CloudKitManager.shared.fetchRecordsOf(type: Song.typeKey, predicate: predicate, database: privateDB) { (records, error) in
            
            if let error = error {
                print("Error fetching songs from CloudKit: \(error.localizedDescription)")
            }
            
            guard let records = records else { completion(); return }
            
            let songs = records.flatMap({ Song(cloudKitRecord: $0) })
            
            playlist.songs = songs
            
            completion()
        }
    }
    
}
