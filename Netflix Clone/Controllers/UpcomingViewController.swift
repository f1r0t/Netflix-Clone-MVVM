//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Fırat AKBULUT on 10.11.2023.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var titles = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white

        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
//upcomingTable'ın boyutunu ve konumunu, bu UIViewController'ın ana view'ının boyutu ve konumuna eşitlemek için kullanılır. Bu sıklıkla, bir alt görünümün veya bir alt görünüm hiyerarşisinin boyutu, konumu veya düzeni, üst sınıf view'ın boyutu veya konumuna bağlı olarak değiştiğinde kullanılır.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.originalTitle ?? title.originalName) ?? "Unknown Name", posterURL: title.posterPath ?? "Unknown Path"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let title = titles[indexPath.row]
            
        guard let titleName = title.originalTitle ?? title.originalName else {
                return
            }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
                    switch result {
                    case .success(let videoElement):
                        DispatchQueue.main.async {
                            let vc = TitlePreviewViewController()
                            vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }

                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
    
    
}
