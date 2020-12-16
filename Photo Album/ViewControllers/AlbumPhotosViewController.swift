

import UIKit
import Alamofire
import Kingfisher

class AlbumPhotosViewController: UIViewController  {

    var album : Album?
    private let refreshControl = UIRefreshControl()
    private var albumPhotosAdapter = AlbumPhotosAdapter()
    
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = album?.title
        
        if #available(iOS 10.0, *) {
            photoListCollectionView.refreshControl = refreshControl
        } else {
            photoListCollectionView.addSubview(refreshControl)
        }
        photoListCollectionView.dataSource = albumPhotosAdapter
        photoListCollectionView.delegate = albumPhotosAdapter
        
        refreshControl.addTarget(self, action: #selector(fetchPhoto(_:)), for: .valueChanged)
        fetchPhotos()
    }
    
    @objc private func fetchPhoto(_ sender: Any) {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let albumId = album?.id else {
            return
        }
        
        Alamofire.request("https://jsonplaceholder.typicode.com/photos?albumId=" + String(albumId)).response {[weak self] response in
            guard let self = self else {
                return
            }
            
            self.refreshControl.endRefreshing()
            
            if let error = response.error {
                print(error)
                return
            }
            
            if let jsonData = response.data, let photos = try? self.newJSONDecoder().decode([Photo].self, from: jsonData) {
                self.albumPhotosAdapter.photos = photos
                self.photoListCollectionView.reloadData()
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
    
}
