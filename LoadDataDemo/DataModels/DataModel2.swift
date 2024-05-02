//
//  DataModel2.swift
//  LoadDataDemo
//
//  Created by nicaho on 2024/5/2.
//

import Foundation
import Combine

class DataModel2: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    @Published var users: [User]?
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadData() {
        isLoading = true
        print("isLoading = true")
        
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
        
        let loadOperation = publisher
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .map { users in
                print("publisher map")
                self.users = users
            }
            .catch { error in
                print("publisher catch")
                return Just(self).map { dataModel in
                    dataModel.isLoading = false
                    dataModel.error = error
                }
            }
            .eraseToAnyPublisher()
        
        loadOperation
            .sink { completion in
                switch completion {
                case .finished:
                    print("loadOperation finished")
                    break
                case .failure(let error):
                    print("loadOperation failure")
                    self.isLoading = false
                    self.error = error
                }
            } receiveValue: { _ in
                print("loadOperation receiveValue")
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
