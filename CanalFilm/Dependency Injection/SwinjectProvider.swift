//
//  SwinjectProvider.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import Foundation
import Swinject

class SwinjectProvider {
    
    // MARK: - Properties
    var container = Container()
    static var shared = SwinjectProvider()
    
    // MARK: - Function
    
    public func registerDependencies() {
        self.container.register(Networking.self, factory: { resolver in
            return API()
        })

        container.register(ListMoviesModeling.self) { resolver in
            ListMoviesModel(apiClient: resolver.resolve(Networking.self))
        }
        
        container.register(MovieDetailModeling.self) { (resolver, url) in
            MovieDetailViewModel(movieUrl: url, apiClient: resolver.resolve(Networking.self))
        }
    }
}
