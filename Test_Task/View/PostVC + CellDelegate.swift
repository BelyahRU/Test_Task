
import UIKit

protocol PostCellDelegate: AnyObject {
    func didTapShowMoreButton(at index: Int)
    func didTapHideButton(at index: Int)
    func didLikePost(_ post: Post, isLiked: Bool)
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
    
    func didLikePost(_ post: Post, isLiked: Bool) {
        viewModel.toggleLike(post: post, isLiked: isLiked)
        if let index = viewModel.posts.firstIndex(where: { $0.id == post.id }) {
            let indexPath = IndexPath(row: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
