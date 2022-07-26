//
//  BackgroundSession.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 26/07/2022.
//

import UIKit

class BackgroundSession: NSObject {
    static let shared = BackgroundSession()
    
    static let identifier = "InesBOKRI.CanalFilm"
    
    private var session: URLSession!

    #if !os(macOS)
    var savedCompletionHandler: (() -> Void)?
    #endif
    
    private override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.background(withIdentifier: BackgroundSession.identifier)
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func start(_ request: URLRequest) {
        session.downloadTask(with: request).resume()
    }
}

extension BackgroundSession: URLSessionDelegate {
    #if !os(macOS)
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            self.savedCompletionHandler?()
            self.savedCompletionHandler = nil
        }
    }
    #endif
}

extension BackgroundSession: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
        }
    }
}

extension BackgroundSession: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            let json = try JSONSerialization.jsonObject(with: data)
            
            print("\(json)")
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
