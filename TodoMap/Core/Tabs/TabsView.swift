//
//  TabsView.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI
import Combine

struct TabsView: View {
    @State var tabSelection: TabBarItem = .todo

    var body: some View {
        CustomTabBarView(selection: $tabSelection) {
            TodoListContentView()
                .tabBarItem(tab: .todo, selection: $tabSelection)
            TodoMapContentView()
                .tabBarItem(
                    tab: .map,
                    selection: $tabSelection
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
