
import UIKit


//MARK: - extension для работы с CollectionView
extension PostsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Количество постов
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = viewModel.posts[indexPath.row]
        cell.configure(with: post, index: indexPath.row, isExpanded: viewModel.expandedPosts.contains(indexPath.row))
        cell.delegate = self // Делегат для работы с viewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = viewModel.posts[indexPath.row]
        let width = collectionView.frame.width - 40
        
        // Высота заголовка
        let newTitleHeight = TextSizeHelper.textHeight(withWidth: 280, font: .boldSystemFont(ofSize: 15), text: post.title) - 18
        
        // Высота основного текста
        let newTextHeight = TextSizeHelper.textHeight(withWidth: 280, font: .systemFont(ofSize: 13), text: post.body) - 60
        
        let height = viewModel.expandedPosts.contains(indexPath.row) ? 172 + newTextHeight + newTitleHeight : 172
        return CGSize(width: width, height: height)
    }
    
    // При скроллинге подгружаем посты
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 2 && !viewModel.isLoading {
            viewModel.fetchPosts()
        }
    }
}
