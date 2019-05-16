//
//  NetworkClient.swift
//  PDContactList
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
import Alamofire

let pipedriveAPIKey = Bundle.main.infoDictionary?["PipedriveAPIKey"] as! String

enum RequestType {
    case fetchContactList
    
    var baseURL: String {
        switch self {
        case .fetchContactList: return "https://api.pipedrive.com/v1/persons?api_token="
        }
    }
    
    var parsingQueueLabel: String {
        switch self {
        case .fetchContactList:
            return "fetchContactList"
        }
    }
    
    func getURLString() -> String {
        switch self {
        case .fetchContactList:
            return baseURL + pipedriveAPIKey
        }
    }
}

protocol NetworkClientType {
    func request<T>(request: RequestType,
                           translator: @escaping (Data) -> (Result<T, Error>),
                           completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkClient: NetworkClientType {
    static let sharedInstance = NetworkClient()
    private init(){}
    
    func request<T>(request: RequestType,
                    translator: @escaping (Data) -> (Result<T, Error>),
                    completion: @escaping (Result<T, Error>) -> Void) {
        
        let queue = DispatchQueue(label: request.parsingQueueLabel,
                                  qos: .background,
                                  attributes: .concurrent)
        
        AF.request(request.getURLString())
            .response(queue: queue, completionHandler: { (dataResponse) in
                if let data = dataResponse.data {
                    precondition(Thread.isMainThread == false)
                    let translated = translator(data)
                    completion((translated))
                } else if let error = dataResponse.error {
                    completion(Result.failure(error))
                } else {
                    let unknownError = NSError.init(domain: "com.david.pdcontactlist", code: -1, userInfo: ["info": "unknown network error"])
                    completion(Result.failure(unknownError))
                }
            })
    }
}
