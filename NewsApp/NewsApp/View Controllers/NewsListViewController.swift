//
//  NewsListViewController.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/9/22.
//

import UIKit

protocol NewsListViewControllerProtocol {
    func goToNewsStoryViewController(with viewModel: StoryViewModel)
}

class NewsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: NewsListViewModel = NewsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        fetchNewsList()
    }
    
    private func loadUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchNewsList() {
        ActivityIndicatorView.start(for: view)
        viewModel.fetchNewsList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(()):
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                    self?.showAlert(message: error.description)
                }
            }
            ActivityIndicatorView.stop()
        }
    }
    
    private func loadImage(row: Int, completion: @escaping (UIImage?) -> ()) {
        guard let urlString = viewModel.newsAtIndex(row).teaserImage?.links.url.href else {
            completion(UIImage(named: "ImageNotAvailable"))
            return
        }
        
        viewModel.fetchImageData(with: urlString) { result in
            if case let .success(data) = result {
                completion(UIImage(data: data))
            } else {
                completion(UIImage(named: "ImageNotAvailable"))
            }
        }
    }
}

// MARK: UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news: News = viewModel.newsAtIndex(indexPath.row)
        
        switch news.type {
        case .story, .weblink:
            let reuseIdentifier = viewModel.getReuseIdentifierAt(indexPath.row)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
                fatalError("NewsTableViewCell not found")
            }
            
            loadImage(row: indexPath.row) { image in
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            }
            
            cell.headlineLabel.text = news.headline
            cell.teaserLabel.text = news.teaserText
            cell.dateLabel.text = viewModel.showDate(news)
            
            return cell
        case .advert:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                fatalError("cell not found")
            }
            
            cell.textLabel?.text = "ADVERT"
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news: News = viewModel.newsAtIndex(indexPath.row)
        
        switch news.type {
        case .story, .weblink:
            if let newsId = news.id {
                let viewModel = StoryViewModel(newsId: newsId)
                goToNewsStoryViewController(with: viewModel)
            }
        case .advert:
            if let urlString = news.url,
               let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: Router
extension NewsListViewController: NewsListViewControllerProtocol {
    func goToNewsStoryViewController(with viewModel: StoryViewModel) {
        let viewController = StoryViewController.instantiate(with: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
