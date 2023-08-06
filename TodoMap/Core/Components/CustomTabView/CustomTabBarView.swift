//
//  CustomTabBarView.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI

struct CustomTabBarView<Content : View>: View {
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = []
    let content: Content

    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            CustomTabBarItemView(
                tabs: tabs,
                selection: $selection,
                localSelection: selection
            )
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [.todo, .map]
    static var previews: some View {
        CustomTabBarView(selection: .constant(tabs.first!)) {
            Color.blue
        }
    }
}
