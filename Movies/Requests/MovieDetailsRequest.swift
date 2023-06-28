//
//  MovieDetailsRequest.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-19.
//

import Foundation
import Fetch

struct MovieDetailsRequest: Request {
    var url: URL
    var method: Fetch.HTTPMethod = .get
    var headers: [String : String]? = nil
    var body: Data? = nil
    
    init(movieId: String) {
        url = URL(string: "https://us-central1-temporary-692af.cloudfunctions.net/movieDetails?id=\(movieId)")!
    }
}

extension MovieDetails: Parsable {
    static func parse(response: Fetch.Response, errorParser: Fetch.ErrorParsing.Type?) -> Fetch.FetchResult<MovieDetails> {

        guard let data = response.data else {
            return .failure(ParseError.invalidData)
        }
        
        let decoder = JSONDecoder()
        do {
            let movieDetails = try decoder.decode(MovieDetails.self, from: data)
            return .success(movieDetails)
        } catch {
            return .failure(error)
        }
    }
}
