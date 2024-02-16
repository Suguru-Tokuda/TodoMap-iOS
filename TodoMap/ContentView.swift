//
//  ContentView.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainCoordinator: MainCoordinator
    
    var body: some View {
        mainCoordinator.build(page: .tabs)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
