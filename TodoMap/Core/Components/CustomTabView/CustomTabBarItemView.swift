//
//  CustomTabBarItemView.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI

struct CustomTabBarItemView: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .frame(minHeight: 15)
        .padding(.top, 5)
        .padding(.bottom, -5)
        .overlay(
            Divider()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .background(Color.theme.secondaryBackground)
            ,
            alignment: .top
        )
        .background(
            Color.theme.background.ignoresSafeArea(edges: .bottom)
        )
        .onChange(of: selection) { newValue in
            withAnimation(.easeInOut) {
                localSelection = newValue
            }
        }
    }
}

extension CustomTabBarItemView {
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}

extension CustomTabBarItemView {
    @ViewBuilder
    private func tabView(tab: TabBarItem) -> some View {
        VStack(spacing: 2) {
            VStack(spacing: 1) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20))
                Text(tab.title)
                    .font(.system(
                          size: 10,
                          weight: .semibold,
                          design: .rounded
                    ))
            }
            .foregroundColor(localSelection == tab ? Color.theme.text : Color.gray)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity)
            
            VStack() {
                if localSelection == tab {
                    Rectangle()
                        .padding(.top, 0)
                        .frame(maxWidth: 30, maxHeight: 3)
                        .cornerRadius(20)
                        .opacity(localSelection == tab ? 1 : 0)
                        .matchedGeometryEffect(id: "tabbar_background", in: namespace)
                }
            }
            .frame(maxWidth: 30, maxHeight: 3)
        }
    }
}

struct CustomTabBarItemView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [.todo, .map]
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarItemView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
        }
        .preferredColorScheme(.dark)
        VStack {
            Spacer()
            CustomTabBarItemView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
        }
    }
}
