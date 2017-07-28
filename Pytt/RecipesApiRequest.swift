//
//  RecipesApiRequest.swift
//  Pytt
//
//  Created by Hosk, Johan on 2017-07-28.
//  Copyright © 2017 Wirecard. All rights reserved.
//

import Foundation


//about http://food2fork.com/about/api
//apiKey = 055a3a352bf62b2fefbc53056a93828b
//All search requests should be made to the base search API URL. http://food2fork.com/api/search
//All recipe requests should be made to this URL: http://food2fork.com/api/get

//Ex search url http://food2fork.com/api/search?key={API_KEY}&q=shredded%20chicken

let apiKey = "055a3a352bf62b2fefbc53056a93828b"
let baseUrl = "http://food2fork.com/api/"
let searchApi = "search?"

struct RecipesApiRequest: ApiRequest {
    
    var urlRequest: URLRequest
    var ingredients: String
    
    init(ingredients: String)  {
        self.ingredients = ingredients
        let escapedIngredients = ingredients.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = baseUrl + searchApi + "key=" + apiKey + "&q=" + escapedIngredients
        let url = URL(string: urlString)!
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
    }
}