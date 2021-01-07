//
//  MoviesViewController.swift
//  MobDev
//
//  Created by POG on 07.01.2021.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var moviesView: MovieListView!
    @IBOutlet weak var movieSearchBar: UISearchBar!

    var movieDetailsView: MovieDetailsView!

    var moviesViewDataSource: MovieList?

    func loadMovies(byRequest: String) {
        DispatchQueue.global().async {
            if let moviesData = try? Data(contentsOf: URL(string: "http://www.omdbapi.com/?apikey=7e9fe69e&s=\(byRequest)&page=1")!) {
                self.moviesViewDataSource = try? JSONDecoder().decode(MovieList.self, from: moviesData)
                DispatchQueue.main.async {
                    self.moviesView.dataSource = self.moviesViewDataSource
                    self.moviesView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        movieSearchBar.delegate = self
        moviesView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        movieDetailsView = segue.destination.view as? MovieDetailsView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = moviesViewDataSource?.Search[indexPath.row]
        DispatchQueue.global().async {
            if let movieDetailsData = try? Data(contentsOf: URL(string: "http://www.omdbapi.com/?apikey=7e9fe69e&i=\(movie!.imdbID)")!) {
                if let movieDetails = try? JSONDecoder().decode(MovieDetails.self, from: movieDetailsData) {
                    DispatchQueue.main.async { self.movieDetailsView.detailsText.text =
        """
        Title: \(movieDetails.Title ?? movie?.Title ?? "-")

        Plot: \(movieDetails.Plot ?? "-")

        Actors: \(movieDetails.Actors ?? "-")

        Awards: \(movieDetails.Awards ?? "-")

        Country: \(movieDetails.Country ?? "-")

        Director: \(movieDetails.Director ?? "-")

        Genre: \(movieDetails.Genre ?? "-")

        Language: \(movieDetails.Language ?? "-")

        Production: \(movieDetails.Production ?? "-")

        Rated: \(movieDetails.Rated ?? "-")

        Released: \(movieDetails.Released ?? "-")

        Runtime: \(movieDetails.Runtime ?? "-")

        Writer: \(movieDetails.Writer ?? "-")

        Year: \(movieDetails.Year ?? movie?.Year ?? "-")

        imdb ID: \(movieDetails.imdbID ?? movie?.imdbID ?? "-")

        imdb Rating: \(movieDetails.imdbRating ?? "-")

        imdb Votes: \(movieDetails.imdbVotes ?? "-")
        """
                    }
                }
            }

            DispatchQueue.main.async {
                if let imageData = try? Data(contentsOf: URL(string: movie!.Poster)!) {
                    self.movieDetailsView.poster.image = UIImage(data: imageData)
                    self.movieDetailsView.activity.stopAnimating()
                }
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            loadMovies(byRequest: searchText.replacingOccurrences(of: " ", with: "+"))
        } else {
            searchBarCancelButtonClicked(searchBar)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        moviesViewDataSource = nil
        moviesView.dataSource = moviesViewDataSource
        moviesView.reloadData()
    }


}
