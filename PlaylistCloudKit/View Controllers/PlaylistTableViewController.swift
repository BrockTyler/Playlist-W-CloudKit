//
//  PlaylistTableViewController.swift
//  PlaylistCloudKit
//
//  Created by brock tyler on 2/28/18.
//  Copyright © 2018 Brock Tyler. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var playlist: Playlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PlaylistController.shared.fetchAllPlaylistsFromCloudKit {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField.text else { return }
        
        PlaylistController.shared.createPlaylistWith(name: name) {
            
            DispatchQueue.main.async {
                self.nameTextField.text = ""
                self.tableView.reloadData()
                
                self.view.endEditing(true)
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PlaylistController.shared.playlists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)

        let playlist = PlaylistController.shared.playlists[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = playlist.name
        cell.detailTextLabel?.text = "\(playlist.songs.count) song(s)"

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPlaylistDetail" {
            
            if let destinationViewController = segue.destination as? SongListTableViewController,
                let index = tableView.indexPathForSelectedRow?.row {
                
                let playlist = PlaylistController.shared.playlists[index]
                destinationViewController.playlist = playlist
            }
        }
    }
 

}
