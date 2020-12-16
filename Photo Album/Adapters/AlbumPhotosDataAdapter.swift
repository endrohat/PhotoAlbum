
import UIKit

public class AlbumPhotosAdapter : NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var photos : [Photo] = []
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(100) as! UIImageView
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: photos[indexPath.row].thumbnailURL))
        return cell
    }
    
}

protocol PhotoClickListner: class {
    func onPhotoClicked(photo : Photo)
}
