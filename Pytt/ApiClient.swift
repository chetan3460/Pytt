//
//  ApiClient.swift
//  Pytt
//
//  Created by Hosk, Johan on 2017-07-28.
//  Copyright © 2017 Johan Hosk. All rights reserved.
//


//Test with https://github.com/kylef-archive/Mockingjay
//or https://github.com/AliSoftware/OHHTTPStubs
//also https://github.com/Quick/Quick
//Use OHHTTPStubs https://github.com/mokacoding/OHHTTPStubsExample

//api client and networking layer inspired by https://github.com/thoughtbot/Swish

import Foundation


protocol ApiRequest {
    var urlRequest: URLRequest { get }
}

protocol ApiClient {
    func execute(request: ApiRequest, completionHandler: @escaping (_ result: Result<ApiResponse>) -> Void)
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class ApiClientImplementation: ApiClient {
    let urlSession: URLSessionProtocol
    
    init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil,
                                delegateQueue: completionHandlerQueue)
    }
    
    // MARK: - ApiClient

    func execute(request: ApiRequest,
                 completionHandler: @escaping (Result<ApiResponse>) -> Void) {
        
        print("Request with url: " + request.urlRequest.url!.absoluteString)
        let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completionHandler(Result.failure(NetworkRequestError(error: error)))
                return
            }
            guard let data = data else {
                completionHandler(Result.failure(NetworkRequestError(error: error)))
                return
            }
    
            let successRange = 200...299
            if successRange.contains(httpUrlResponse.statusCode) { //Got response
                completionHandler(Result.success(ApiResponse(data:data, httpUrlResponse: httpUrlResponse)))
            } else {
                completionHandler(Result.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse)))
            }
        }
        dataTask.resume()
    }
}
