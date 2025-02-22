
//
//  HTTPClient.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import Foundation
import RxSwift

class HTTPClient {
    static let shared = HTTPClient()
    let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ path: String) -> Observable<T> {
        let baseURL = AppConfig.baseURL
        let apiKey = AppConfig.apiKey
        guard let url = URL(string: "\(baseURL)\(path)") else {
            return .error(NSError(domain: "InvalidURL", code: -1, userInfo: nil))
        }
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-access-token")
        return Observable.create { observer in
            let task = self.session.dataTask(with: request) { data, response, error in
               // print(String(data: data!, encoding: .utf8))
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else {
                    observer.onError(NSError(domain: "NoData", code: -1, userInfo: nil))
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decoded)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
