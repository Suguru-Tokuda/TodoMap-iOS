//
//  TabsView.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI
import Combine

struct TabsView: View {
    @EnvironmentObject var mainCoordinator: MainCoordinator

    var body: some View {
        CustomTabBarView(selection: $mainCoordinator.tabSelection) {
            TodoListContentView()
                .tabBarItem(tab: .todo, selection: $mainCoordinator.tabSelection)
            TodoMapContentView()
                .tabBarItem(
                    tab: .map,
                    selection: $mainCoordinator.tabSelection
                )
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
            .preferredColorScheme(.dark)
        TabsView()
    }
}
