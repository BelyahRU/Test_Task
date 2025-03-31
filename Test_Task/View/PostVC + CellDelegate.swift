
import UIKit

protocol PostCellDelegate: AnyObject {
    func didTapShowMoreButton(at index: Int)
    func didTapHideButton(at index: Int)
    func didLikePost(_ post: Post, isLiked: Bool)
}


extension PostsViewController: PostCellDelegate {
    
    /// Метод для увеличения размера ячейки в соответствии с размером текста
    func didTapShowMoreButton(at index: Int) {
        viewModel.expandedPosts.append(index)
        collectionView.reloadData()
    }
    
    /// Метод для уменьшения ячейки до стандартной
    func didTapHideButton(at index: Int) {
        viewModel.expandedPosts.removeAll(where: {$0 == index})
        collectionView.reloadData()
    }
    
    /// Метод для обработки лайка
    func didLikePost(_ post: Post, isLiked: Bool) {
        viewModel.toggleLike(post: post, isLiked: isLiked)
        if let index = viewModel.posts.firstIndex(where: { $0.id == post.id }) {
            let indexPath = IndexPath(row: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
