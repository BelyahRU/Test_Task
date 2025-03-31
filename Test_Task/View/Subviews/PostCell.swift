
import UIKit

class PostCell: UICollectionViewCell {
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.text = "Aleksandr Andreev"
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View more", for: .normal)
        button.setTitleColor(Resources.Colors.baseGreenColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    private var hideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hide", for: .normal)
        button.setTitleColor(Resources.Colors.baseGreenColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    private var heartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "heartImage"), for: .normal)
        return button
    }()
    
    private var personImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    weak var delegate: PostCellDelegate?
    var index: Int!
    var post: Post!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupContentView()
        setupTargets()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupContentView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.white
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(showMoreButton)
        contentView.addSubview(hideButton)
        contentView.addSubview(personImage)
        contentView.addSubview(heartButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            personImage.widthAnchor.constraint(equalToConstant: 40),
            personImage.heightAnchor.constraint(equalToConstant: 40),
            personImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            personImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 280),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38),
            titleLabel.widthAnchor.constraint(equalToConstant: 280),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            bodyLabel.widthAnchor.constraint(equalToConstant: 280),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            
            showMoreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -38),
            showMoreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            showMoreButton.widthAnchor.constraint(equalToConstant: 70),
            
            hideButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            hideButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            hideButton.widthAnchor.constraint(equalToConstant: 40),
            
            heartButton.widthAnchor.constraint(equalToConstant: 37),
            heartButton.heightAnchor.constraint(equalToConstant: 37),
            heartButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            heartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)

        ])
    }
    
    private func setupTargets() {
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
        hideButton.addTarget(self, action: #selector(didTapHide), for: .touchUpInside)
        heartButton.addTarget(self, action: #selector(heartPressed), for: .touchUpInside)
    }
    
    func configure(with post: Post, index: Int, isExpanded: Bool) {
        self.index = index
        self.post = post
        titleLabel.text = post.title
        bodyLabel.text = post.body
        nameLabel.text = post.name ?? "Unknown User"
        
        if let avatarName = post.avatar {
            personImage.image = UIImage(named: avatarName)
        } else {
            personImage.image = UIImage(named: "defaultAvatar")
        }

        // Устанавливаем лайк
        let heartImage = post.isLiked ? "heartImageSelected" : "heartImage"
        heartButton.setImage(UIImage(named: heartImage), for: .normal)

        bodyLabel.numberOfLines = isExpanded ? 0 : 3
        titleLabel.numberOfLines = isExpanded ? 0 : 1
        showMoreButton.isHidden = isExpanded
        hideButton.isHidden = !isExpanded
    }

    
    @objc func didTapShowMore() {
        delegate?.didTapShowMoreButton(at: index)  // Уведомляем контроллер, что нужно развернуть ячейку
    }
    
    @objc func didTapHide() {
        delegate?.didTapHideButton(at: index)  // Уведомляем контроллер, что нужно скрыть ячейку
    }
    
    @objc func heartPressed() {
        if heartButton.currentImage == UIImage(named: "heartImage") {
            heartButton.setImage(UIImage(named: "heartImageSelected"), for: .normal)
            delegate?.didLikePost(post, isLiked: true)
        } else {
            heartButton.setImage(UIImage(named: "heartImage"), for: .normal)
            delegate?.didLikePost(post, isLiked: false)
        }
    }
}

