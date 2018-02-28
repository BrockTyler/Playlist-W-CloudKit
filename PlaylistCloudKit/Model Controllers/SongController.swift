//
//  SongController.swift
//  PlaylistCloudKit
//
//  Created by brock tyler on 2/28/18.
//  Copyright © 2018 Brock Tyler. All rights reserved.
//

import Foundation
import CloudKit

class SongController {
    
    static func createSongWith(title: String, artist: String, playlist: Playlist, completion: @escaping () -> Void) {
        
        let song = Song(title: title, artist: artist, playlist: playlist)
        
        let record = song.cloudKitRecord
        
        CloudKitManager.shared.saveRecordToCloudKit(record: record, database: PlaylistController.shared.privateDB) { (record, error) in
            
            if let error = error {
                print("Error saving song record to CloudKit: \(error.localizedDescription)")
            } else {
                song.cloudKitRecordID = record?.recordID
                playlist.songs.append(song)
            }
            
            completion()
        }
    }
}
