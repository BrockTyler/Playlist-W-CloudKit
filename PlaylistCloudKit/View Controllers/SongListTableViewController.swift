//
//  SongListTableViewController.swift
//  PlaylistCloudKit
//
//  Created by brock tyler on 2/28/18.
//  Copyright © 2018 Brock Tyler. All rights reserved.
//

import UIKit

class SongListTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    
    var playlist: Playlist?
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let artist = artistTextField.text,
            let playlist = playlist else { return }
        
        SongController.createSongWith(title: title, artist: artist, playlist: playlist) {
            
            DispatchQueue.main.async {
                self.titleTextField.text = ""
                self.artistTextField.text = ""
                self.tableView.reloadData()
                
                self.view.endEditing(true)
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let playlist = playlist else { return 0 }
        
        return playlist.songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)

        let song = playlist?.songs[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = song?.title
        cell.detailTextLabel?.text = song?.artist
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
