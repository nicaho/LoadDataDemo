//
//  ContentView.swift
//  LoadDataDemo
//
//  Created by nicaho on 2024/5/2.
//

import SwiftUI

/// 使用 Observation 请求网络数据
struct ContentView: View {
    @State private var dataModel1 = DataModel1()
    
    var body: some View {
        VStack {
            if dataModel1.isLoading {
                ProgressView()
            } else if let data = dataModel1.users {
                NavigationStack {
                    List {
                        ForEach(data) { user in
                            NavigationLink {
                                List(user.friends) { friend in
                                    Text("\(friend.name)")
                                }
                                .navigationTitle("\(user.name)")
                            } label: {
                                HStack {
                                    Text(user.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(user.isActive ? "Active" : "notActive")
                                        .font(.title2)
                                }
                            }
                        }
                    }
                    .navigationTitle("User & Frieds")
                }
            } else if let error = dataModel1.error {
                Text("加载失败: \(error.localizedDescription)")
            }
        }
        .onAppear {
            Task {
                await dataModel1.loadData()
            }
        }
    }
}

/// 使用 Combine 请求网络数据
struct ContentView2: View {
    @StateObject private var dataModel2 = DataModel2()
    
    var body: some View {
        VStack {
            if dataModel2.isLoading {
                ProgressView()
            } else if let data = dataModel2.users {
                NavigationStack {
                    List {
                        ForEach(data) { user in
                            NavigationLink {
                                List(user.friends) { friend in
                                    Text("\(friend.name)")
                                }
                                .navigationTitle("\(user.name)")
                            } label: {
                                HStack {
                                    Text(user.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(user.isActive ? "Active" : "notActive")
                                        .font(.title2)
                                }
                            }
                        }
                    }
                    .navigationTitle("User & Frieds")
                }
            } else if let error = dataModel2.error {
                Text("加载失败: \(error.localizedDescription)")
            }
        }
        .onAppear {
            dataModel2.loadData()
        }
    }
}

#Preview {
    ContentView()
//    ContentView2()
}
