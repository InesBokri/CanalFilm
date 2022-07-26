//
//  API.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import RxCocoa
import RxSwift

class API: Networking {
    
    public init() { }
    
    func fetchData<T: Codable>(url: String) -> Observable<T> {
        return Observable<T>.create { [weak self] observer in
            guard self != nil else { return Disposables.create() }
            guard let request = URL(string: url) else {
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext( model )
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
