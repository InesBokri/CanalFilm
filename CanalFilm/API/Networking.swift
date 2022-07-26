//
//  Networking.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import RxCocoa
import RxSwift

public protocol Networking {

    func fetchData<T: Codable>(url: String) -> Observable<T>
}
