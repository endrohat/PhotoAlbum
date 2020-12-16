

import UIKit

public class AlbumDataAdapter : NSObject, UITableViewDataSource, UITableViewDelegate {
    
     var albums : [Album] = []
     weak var albumClickListener : AlbumClickListner?
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        cell.textLabel?.text = albums[indexPath.row].title
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        albumClickListener?.onAlbumClicked(album: albums[indexPath.row])
    }
}

protocol AlbumClickListner: class {
    func onAlbumClicked(album : Album)
}
