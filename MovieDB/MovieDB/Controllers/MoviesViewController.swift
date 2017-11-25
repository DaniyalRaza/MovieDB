//
//  MoviesViewController.swift
//  MovieDB
//
//  Created by Invision on 25/11/2017.
//  Copyright © 2017 Daniyal Raza. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController{
    
    //MARK: IBOutles
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    let cellReuseIdentifier = "MovieCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoviesManager.shared.updateResults()
        MoviesManager.shared.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Register keyboard listener to adjust tableview
        self.registerKeyboardNotifications()
    }
    
    //Toggle hide suggestion tableview
    func toggleSuggestions(){
        suggestionsTableView.isHidden = !suggestionsTableView.isHidden
    }
}

//MARK: Datasource Methods
extension MoviesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == suggestionsTableView{
            return SearchHistory.suggestions.count
        }
        return MoviesManager.shared.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == suggestionsTableView{
            let cell = UITableViewCell()
            cell.textLabel?.text = SearchHistory.suggestions[indexPath.row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MovieTableViewCell
        cell.movie = MoviesManager.shared.movies[indexPath.row]
        return cell        
    }
}

//MARK: Delegate Methods
extension MoviesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestionsTableView{
            guard let cell = tableView.cellForRow(at: indexPath) else {return}
            movieSearchBar.text = cell.textLabel?.text
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == MoviesManager.shared.movies.count-1{
            MoviesManager.shared.currentQuery = movieSearchBar.text
        }
    }
}

extension MoviesViewController: MoviesDelegate{
    
    //Reload tableview to reflect updated model
    func moviesFetched() {
        moviesTableView.reloadData()
    }
    
    //Show alert for failed search
    func movieFetchFailed(message: String) {
        self.showAlert(title: "Oops", message: message)
    }
    
    
}

extension MoviesViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        MoviesManager.shared.currentQuery = searchBar.text
        searchBar.endEditing(true)
        toggleSuggestions()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        suggestionsTableView.reloadData()
        toggleSuggestions()
    }
}

extension MoviesViewController: KeyboardHandler{
    
    var bottomConstraint: NSLayoutConstraint{
        return bottomLayoutConstraint
    }
    
}
