
import UIKit

protocol PostCellDelegate: AnyObject {
    func didTapShowMoreButton(at index: Int)
    func didTapHideButton(at index: Int)
}


extension PostsViewController: PostCellDelegate {
    func didTapShowMoreButton(at index: Int) {
        viewModel.expandedPosts.append(index)
        collectionView.reloadData()
    }
    
    func didTapHideButton(at index: Int) {
        viewModel.expandedPosts.removeAll(where: {$0 == index})
        collectionView.reloadData()
    }
}
