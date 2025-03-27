
import UIKit

extension PostsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.configure(with: post, index: indexPath.row, isExpanded: expandedPosts.contains(indexPath.row))
        cell.delegate = self
        return cell
    }
    
    // Динамическое изменение размера ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = posts[indexPath.row]
        let width = collectionView.frame.width - 40
        
        
        //base titleHeight = 18
        let newTitleHeight = TextSizeHelper.textHeight(withWidth: 280, font: .boldSystemFont(ofSize: 15), text: post.title) - 18
        
        //base textHeight = 60
        let newTextHeight = TextSizeHelper.textHeight(withWidth: 280, font: .systemFont(ofSize: 13), text: post.body) - 60
        
        // Если ячейка развернута, увеличиваем размер
        let height = expandedPosts.contains(indexPath.row) ? 172 + newTextHeight + newTitleHeight : 172
        return CGSize(width: width, height: height)
    }
    
}
