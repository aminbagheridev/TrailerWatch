//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit


enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {

    // setting the hero header view to be available all throughout the class
    private var headerView: HeroHeaderUIView?
    private var randomTrendingMovie: Title?
    
    
    // creating section header titles:
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    // creating table view
    private let homeFeedTable: UITableView = {
        // .zero as frame because we already layed that out in view did layout subviews method
        let table = UITableView(frame: .zero, style: .grouped) // initializing with headers
        // registering normal cell
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .systemBackground
        
        //ading table view to the homevc
        view.addSubview(homeFeedTable)
        
        //setting data source and delegates for the table view
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        //setting a header for the entire table view, this d=IS NOT the individual headers we set for each table view cell. THE HEADER WE ARE CHOOSING IS GOING TO BE THE UIVIEW WE INITIALIZED OF COURSE
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        
        // configuring hero header uiview image
        configureHeroHeaderView()
        
        // configuring the navigation bar
        configureNavbar()
    }
    
    private func configureHeroHeaderView() {
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                // returns a random element from the collection of titles we pulled
                let selectedTitle = titles.randomElement()
                
                self?.randomTrendingMovie = selectedTitle
                // we create the instance of titleViewModel here. we are basically passing in the parameters from title, into title view model
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print("Error: ", error.localizedDescription)
            }
        }
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "1stmanLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        let color = UIColor.init(hexString: "#0093D6")
        navigationController?.navigationBar.tintColor = color
    }
    
    // giving the table view a frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // this sets it so it covers the entirety of the view, which haopoens to be the whole screen
        homeFeedTable.frame = view.bounds
    }
    
    
    
}


// conforming to table view
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // configuring each cell in the table view to be of type collectionview table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        // we are checking hat section we are accessing fort he cells. sections are 0,1,2,3,4 respectively. (CHECK ENUM AT TOP OF FILE)
        switch indexPath.section {
            // we must type in .rawValue to access the VALUES THAT WE SET upon creating the enum(again, 0,1,2,3,4)
        case Sections.TrendingMovies.rawValue:
            // here we cal the api and get the results from the api back into a model of type Title
            APICaller.shared.getTrendingMovies { result in
                // swithcing the result because we can have either ERROR, or the results we wanted
                switch result {
                    // if successful, put the type into a constant called titles
                case .success(let results):
                    cell.configure(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            
            }
           
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result {
                case .success(let results):
                    // configure uses the sd web image to set and cache the images
                    cell.configure(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let results):
                    // configure uses the sd web image to set and cache the images
                    cell.configure(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let results):
                    // configure uses the sd web image to set and cache the images
                    cell.configure(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let results):
                    // configure uses the sd web image to set and cache the images
                    cell.configure(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    //setting the height for cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // Asks the delegate for the height to use for the header of a particular section.
 func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // changing the font of the headerviews
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // this header is of type header footer view which is of type UIView
        guard let header = view as? UITableViewHeaderFooterView else { return }
        // changing the font of each header text label
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        // setting the text to start coming off 20 from the top left corner
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.localizedCapitalized
    }
    
    
    // setting the titles for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // algortihm to allow for hiding the nav bar when we scroll down, and sticking to the top when scrolling up
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top // the line right under the notch
        let offset = scrollView.contentOffset.y + defaultOffset// the space under the defualt offset and the scroll view going down
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset) )
        
    }
    
}

extension HomeViewController: CollectionTableViewCellDelegate {
    
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [self] in
            let vc = TitlePreviewViewController()
            
            vc.configure(with: viewModel)
            vc.navigationController?.navigationBar.tintColor = firstManColor
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
