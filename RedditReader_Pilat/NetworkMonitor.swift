//
//  NetworkMonitor.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 22.04.2025.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    private var isConnected: Bool = false
    
    private init() {
        
        self.monitor = NWPathMonitor()
        self.isConnected = false
        
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            print("NetworkMonitor: Network status changed - isConnected: \(self.isConnected)")
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        self.isConnected = self.monitor.currentPath.status == .satisfied
    }
    
    func isNetworkAvailable() -> Bool {
        return isConnected
    }
}
