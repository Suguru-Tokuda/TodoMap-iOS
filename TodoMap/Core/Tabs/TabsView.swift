//
//  TabsView.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI

struct TabsView: View {
    @State var tabSelection: TabBarItem = .todo

    var body: some View {
        CustomTabBarView(selection: $tabSelection) {
            ZStack() {
                Color.blue.ignoresSafeArea()
                VStack {
                    Text(String.constants.todo)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .tabBarItem(
                tab: .todo,
                selection: $tabSelection
            )
            ZStack() {
                Color.green.ignoresSafeArea()
                VStack {
                    Text(String.constants.map)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
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
