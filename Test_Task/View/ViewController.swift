import UIKit
import Alamofire

class PostsViewController: UIViewController {
    
    var posts = [Post]()
    var collectionView: UICollectionView!
    var loadingIndicator: UIActivityIndicatorView!
    var expandedPosts = Set<Int>()  // Массив индексов развернутых ячеек
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupLoadingIndicator()
        fetchPosts()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 150)  // Начальная высота ячеек
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
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
        
        // Рассчитываем высоту текста
        let titleHeight = post.title.height(withConstrainedWidth: width, font: UIFont.boldSystemFont(ofSize: 16))
        let bodyHeight = post.body.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 14))
        
        // Если ячейка развернута, увеличиваем размер
        let height = expandedPosts.contains(indexPath.row) ? titleHeight + bodyHeight + 100 : titleHeight + bodyHeight + 50  // 70 для "Показать еще" и "Скрыть"
        return CGSize(width: width, height: height)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.height
    }
}

protocol PostCellDelegate: AnyObject {
    func didTapShowMoreButton(at index: Int)
    func didTapHideButton(at index: Int)
}

class PostCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var bodyLabel: UILabel!
    var showMoreButton: UIButton!
    var hideButton: UIButton!
    weak var delegate: PostCellDelegate?
    var index: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.systemGray5
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
        
        bodyLabel = UILabel()
        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 3
        bodyLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(bodyLabel)
        
        showMoreButton = UIButton()
        showMoreButton.setTitle("Показать еще", for: .normal)
        showMoreButton.setTitleColor(.systemBlue, for: .normal)
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
        contentView.addSubview(showMoreButton)
        
        hideButton = UIButton()
        hideButton.setTitle("Скрыть", for: .normal)
        hideButton.setTitleColor(.systemRed, for: .normal)
        hideButton.addTarget(self, action: #selector(didTapHide), for: .touchUpInside)
        contentView.addSubview(hideButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            showMoreButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            showMoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            hideButton.topAnchor.constraint(equalTo: showMoreButton.bottomAnchor, constant: 8),
            hideButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            hideButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with post: Post, index: Int, isExpanded: Bool) {
        self.index = index
        titleLabel.text = post.title
        bodyLabel.text = post.body
        
        bodyLabel.numberOfLines = isExpanded ? 0 : 3
        showMoreButton.isHidden = isExpanded
        hideButton.isHidden = !isExpanded
    }
    
    @objc func didTapShowMore() {
        delegate?.didTapShowMoreButton(at: index)  // Уведомляем контроллер, что нужно развернуть ячейку
    }
    
    @objc func didTapHide() {
        delegate?.didTapHideButton(at: index)  // Уведомляем контроллер, что нужно скрыть ячейку
    }
}

extension PostsViewController: PostCellDelegate {
    func didTapShowMoreButton(at index: Int) {
        expandedPosts.insert(index)
        collectionView.reloadData()
    }
    
    func didTapHideButton(at index: Int) {
        expandedPosts.remove(index)
        collectionView.reloadData()
    }
}
