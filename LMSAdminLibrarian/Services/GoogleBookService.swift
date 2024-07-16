//
//  BookSearchAPI.swift
//  LMSAdminLibrarian
//
//  Created by Vanshaj on 10/07/24.
//

import Foundation

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

final class GoogleBookService {
    // Fetches book data from the API
    private func fetchBookInfoFromAPI(for isbn: String) async throws -> BooksAPI {
        let urlString = "https://www.googleapis.com/books/v1/volumes"
        let queryParams = ["q": "isbn:\(isbn)"]
        
        guard var url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        url = url.appendingQueryParameters(queryParams)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            return try JSONDecoder().decode(BooksAPI.self, from: data)
        } catch {
            throw NSError(domain: "Decoding Error", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
        }
    }
    
    
    // Fetches book metadata from the API
    func getBookMetaData(isbn: String) async throws -> BooksAPI {
        do {
            return try await fetchBookInfoFromAPI(for: isbn)
        } catch {
            print("Error fetching data for ISBN \(isbn): \(error)")
            throw error
        }
    }
    
    func createGoogleBookMetaData(isbn: String) async throws -> GoogleBookMetaData {
        do {
            let bookAPI = try await getBookMetaData(isbn: isbn)
            guard let bookItem = bookAPI.items.first else {
                throw NSError(domain: "No book found", code: 404, userInfo: nil)
            }
            
            let volumeInfo = bookItem.volumeInfo
            let coverImageLink = volumeInfo.imageLinks?.thumbnail ?? "Default Image"
            
            return GoogleBookMetaData(
                id: UUID().uuidString,
                title: volumeInfo.title,
                authors: volumeInfo.authors.joined(separator: ", "),
                genre: volumeInfo.categories?.joined(separator: ", ") ?? "Unknown",
                publishedDate: volumeInfo.publishedDate,
                pageCount: volumeInfo.pageCount,
                language: volumeInfo.language,
                coverImageLink: coverImageLink,
                description: volumeInfo.description,
                isbn: isbn
            )
        } catch {
            print("Error creating GoogleBookMetaData for ISBN \(isbn): \(error.localizedDescription)")
            throw error
        }
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

