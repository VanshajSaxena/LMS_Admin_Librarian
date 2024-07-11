//
//  BookSearchManager.swift
//  LMSAdmin
//
//  Created by Hitesh Rupani on 04/07/24.
//

import Foundation

class BookSearchManager {
    func getBookInfo(isbn: String, completion: @escaping (BooksAPI) -> Void) {
        /* Configure session, choose between:
           * defaultSessionConfiguration
           * ephemeralSessionConfiguration
           * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default

        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        /* Create the Request:
           ISBN (GET https://www.googleapis.com/books/v1/volumes)
         */

        guard var URL = URL(string: "https://www.googleapis.com/books/v1/volumes") else {return}
        let URLParams = [
            "q": "isbn:\(isbn)",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                guard let jsonData = data else { return }
                
                do {
                    let bookData = try JSONDecoder().decode(BooksAPI.self, from: jsonData)
                    completion(bookData)
                } catch {
                    print(error)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
