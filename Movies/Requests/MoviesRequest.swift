//
//  MoviesRequest.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-19.
//

import Foundation
import Fetch

struct MoviesRequest: Request {
    var url = URL(string: "https://us-central1-temporary-692af.cloudfunctions.net/movies")!
    var method: Fetch.HTTPMethod = .get
    var headers: [String : String]? = nil
    var body: Data? = nil
}

struct MoviesResponse: Parsable {
    let movies: [MovieShortDetails]
    
    static func parse(response: Fetch.Response, errorParser: Fetch.ErrorParsing.Type?) -> Fetch.FetchResult<MoviesResponse> {

        guard let data = response.data else {
            return .failure(ParseError.invalidData)
        }
        
        let decoder = JSONDecoder()
        do {
            let movies = try decoder.decode([MovieShortDetails].self, from: data)
            return .success(MoviesResponse(movies: movies))
        } catch {
            return .failure(error)
        }
    }
}

public enum ParseError : Error {
    case invalidData
}
