//
//  MoviesViewController.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import UIKit
import RxSwift

private let cellIdentifier = "MovieCell"

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchButton = UIBarButtonItem(systemItem: .search)
    var cencelButton = UIBarButtonItem(systemItem: .cancel)
    
    private let bag = DisposeBag()
    private let viewModel = MoviesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rx.setDelegate(self).disposed(by: bag)
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        viewModel.movies.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: MovieTableViewCell.self)) { (row, item, cell) in
            
            cell.titleLabel?.text = item.title
            cell.descriptionLabel?.text = item.description
            cell.movieInfoLabel?.text = item.releaseDate
            cell.voteLabel?.text = "\(item.voteCount)"
            cell.movieLanguageLabel?.text = item.language.uppercased()
            
            if let stackView = cell.voteStackView {
                Helper.shared.setStarts(Int(item.voteAverage/2), stackView: stackView)
            }
            
            if let url = URL(string: item.posterUrl) {
                cell.posterImage?.imageByUrl(from: url)
            }
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Movie.self).subscribe(onNext: { item in
            
            self.performSegueWithIdentifier(identifier: "MovieDetailsSegue", sender: nil) { segue in
                if let vc = segue.destination as? MovieDetailsViewController {
                    vc.movieId = item.id
                }
            }
        }).disposed(by: bag)
        
        viewModel.fetchMovies()
    }
    
    private func setupSearchBar() {
        searchButton.tintColor = .gray
        cencelButton.tintColor = .gray
        self.navigationItem.rightBarButtonItem = searchButton
        
        let searchBar = UISearchBar()
        searchBar.searchTextField
            .rx
            .controlEvent(.editingChanged)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.viewModel.searchMovie(query: text)
            }).disposed(by: bag)
        
        searchButton.rx.tap.bind {
            self.navigationItem.titleView = searchBar
            self.navigationItem.rightBarButtonItem = self.cencelButton
        }.disposed(by: bag)
        
        cencelButton.rx.tap.bind {
            self.navigationItem.titleView = .none
            self.navigationItem.rightBarButtonItem = self.searchButton
            self.viewModel.query = ""
            self.viewModel.fetchMovies()
        }.disposed(by: bag)
    }
}

extension MoviesViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < 164 {
            viewModel.nextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
}
