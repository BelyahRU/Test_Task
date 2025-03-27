import UIKit
import Alamofire

class PostsViewController: UIViewController {
    
    var posts = [Post]()
    var collectionView: UICollectionView!
    var loadingIndicator: UIActivityIndicatorView!
    var expandedPosts = Array<Int>()  // Массив индексов развернутых ячеек
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupCollectionView()
        setupLoadingIndicator()
        fetchPosts()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 172)  // Начальная высота ячеек
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
        loadingIndicator.center = view.center
        loadingIndicator.color = .gray
        view.addSubview(loadingIndicator)
    }
    
    func fetchPosts() {
        loadingIndicator.startAnimating()
        
        let fetcher = PostsDataFetcher()
        fetcher.fetchPosts { result in
            switch result {
            case .success(let posts):
                self.posts = posts
                self.collectionView.reloadData()
            case .failure(let error):
                print("Ошибка при получении постов: \(error)")
            }
            
            self.loadingIndicator.stopAnimating()
        }
    }
}

