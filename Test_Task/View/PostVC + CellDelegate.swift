
import UIKit

protocol PostCellDelegate: AnyObject {
    func didTapShowMoreButton(at index: Int)
    func didTapHideButton(at index: Int)
}


extension PostsViewController: PostCellDelegate {
    func didTapShowMoreButton(at index: Int) {
        expandedPosts.append(index)
        collectionView.reloadData()
    }
    
    func didTapHideButton(at index: Int) {
        expandedPosts.removeAll(where: {$0 == index})
        collectionView.reloadData()
    }
}
