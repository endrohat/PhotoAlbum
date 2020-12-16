//
//  AlbumViewController.swift
//  Photo Album
//
//  Created by indraneel on 21/05/19.
//  Copyright © 2019 indraneel. All rights reserved.
//

import UIKit
import Alamofire

class AlbumViewController: UIViewController, AlbumClickListner {


    @IBOutlet weak var albumListTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let albumDataAdapter = AlbumDataAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            albumListTableView.refreshControl = refreshControl
        } else {
            albumListTableView.addSubview(refreshControl)
        }
        
        albumListTableView.dataSource = albumDataAdapter
        albumListTableView.delegate = albumDataAdapter
        albumDataAdapter.albumClickListener = self
        
        refreshControl.addTarget(self, action: #selector(refreshAlbums(_:)), for: .valueChanged)
        fetchAlbums()
    }
    
    @objc private func refreshAlbums(_ sender: Any) {
        fetchAlbums()
    }
    
    func fetchAlbums() {
        Alamofire.request("https://jsonplaceholder.typicode.com/albums").response {[weak self] response in
            guard let self = self else {
                return
            }
            
            self.refreshControl.endRefreshing()
            
            if let error = response.error {
                print(error)
                return
            }
            
            if let jsonData = response.data , let albums = try? self.newJSONDecoder().decode([Album].self, from: jsonData) {
                self.albumDataAdapter.albums = albums
                self.albumListTableView.reloadData()
            }
            
        }
    }
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    func onAlbumClicked(album: Album) {
         self.performSegue(withIdentifier: "PhotoListSegue", sender:  album)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let album = sender as! Album
        let albumPhotosViewController = segue.destination as! AlbumPhotosViewController
        albumPhotosViewController.album = album
    }
}
