//
//  MovieStruct.swift
//  MobDev
//
//  Created by POG on 07.01.2021.
//

import UIKit


struct Movie: Decodable {
    var Title: String
    var Year: String
    var Poster: String

    var imdbID: String
}

struct MovieDetails: Decodable {
    var imdbID: String?

    var Title: String?
    var Year: String?
    var Rated: String?
    var Released: String?
    var Runtime: String?
    var Genre: String?
    var Director: String?
    var Writer: String?
    var Actors: String?
    var Plot: String?
    var Language: String?
    var Country: String?
    var Awards: String?
    var Poster: String?
    var imdbRating: String?
    var imdbVotes: String?
    var Production: String?
}

class MovieList: NSObject, Decodable, UITableViewDataSource {

    var Search: [Movie]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Search.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as! MovieCell
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: URL(string: self.Search[indexPath.row].Poster)!) {
                DispatchQueue.main.async { cell.filmImage.image = UIImage(data: imageData) }
            }
        }
        cell.filmLabel.text = Search[indexPath.row].Title
        cell.year.text = Search[indexPath.row].Year
        return cell
    }
}
