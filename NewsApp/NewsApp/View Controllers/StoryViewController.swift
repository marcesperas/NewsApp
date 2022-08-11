//
//  StoryViewController.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import UIKit

class StoryViewController: UIViewController, ViewModelBasedProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headlineImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    
    var viewModel: StoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStory()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let headerView = tableView.tableHeaderView else {
            return
        }

        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height

            tableView.tableHeaderView = headerView

            tableView.layoutIfNeeded()
        }
    }
    
    private func loadUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
        loadImage(urlString: viewModel.imageUrl) { image in
            DispatchQueue.main.async {
                self.headlineImageView.image = image
                self.headlineImageView.layoutIfNeeded()
            }
        }
        
        self.headlineLabel.text = viewModel.headline
    }
    
    private func fetchStory() {
        ActivityIndicatorView.start(for: view)
        viewModel.fetchStory { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(()):
                    self?.loadUI()
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                    self?.showAlert(message: error.description)
                }
            }
            ActivityIndicatorView.stop()
        }
    }
    
    private func loadImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
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
extension StoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let content: Content = viewModel.contentAtIndex(indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.getReuseIdentifier(content.type),
                                                       for: indexPath) as? ContentTableViewCell
        else {
            fatalError("ContentTableViewCell or contentType not found")
        }
        
        if content.type == .paragraph {
            cell.contentLabel.text = content.text
        }
        
        if content.type == .image,
           let urlString = content.url {
            loadImage(urlString: urlString) { image in
                DispatchQueue.main.async {
                    cell.contentImageView.image = image
                }
            }
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension StoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
