//
//  DataModel1.swift
//  LoadDataDemo
//
//  Created by nicaho on 2024/5/2.
//

import Foundation
import Observation

@Observable
class DataModel1 {
    var isLoading = false
    var error: Error?
    var users: [User]?
    
    func loadData() async {
        isLoading = true
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            isLoading = false
            
            
            do {
                let decoder = JSONDecoder()
                let reponse = try decoder.decode([User].self, from: data)
                self.users = reponse
                print("reponse success: users")
            } catch {
                print("reponse error1: \(error)")
            }
        } catch {
            isLoading = false
            self.error = error
            print("reponse error2: \(error)")
        }
    }
}
