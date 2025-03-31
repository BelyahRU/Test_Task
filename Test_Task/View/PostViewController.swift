import UIKit
import Alamofire

class PostsViewController: UIViewController {
    
    var viewModel = PostsViewModel()
    var collectionView: UICollectionView!
    var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
//        print(CoreDataManager.shared.removeAll())
        setupCollectionView()
        setupLoadingIndicator()
        setupBindings()
        viewModel.fetchPosts()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 172)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
    }
    
    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - 50)
        view.addSubview(loadingIndicator)
    }
    
    func setupBindings() {
        viewModel.onPostsUpdated = { [weak self] in
            self?.collectionView.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
        }
    }
}
