//
//  TodoItemNameLocationEditView.swift
//  TodoMap
//
//  Created by Suguru on 8/9/23.
//

import SwiftUI

struct TodoItemNameLocationEditView: View {
    @ObservedObject var vm: TodoItemListEditViewModel
    @EnvironmentObject var coordinator: TodoListCoordinator
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                TextField("Name", text: $vm.todoItemList.name)
                    .font(.system(size: 33))
                    .fontWeight(.bold)
                HStack {
                    Text(vm.todoItemList.location?.name ?? "Location")
                        .opacity(vm.todoItemList.location?.name.isEmpty ?? true ? 0.6 : 1)
                        .disabled(true)
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.secondaryText)
                    Spacer()
                    mapBtn()
                }
                .onTapGesture {
                    coordinator.fullScreenCover = .map
                }
            }
        }
        .frame(height: 100)
    }
}

extension TodoItemNameLocationEditView {
    @ViewBuilder
    private func mapBtn() -> some View {
        Button {
            coordinator.fullScreenCover = .map
        } label: {
            ZStack {
                Circle()
                    .fill(Color.theme.secondaryBackground)
                    .frame(width: 20, height: 20)
                Image(systemName: "map")
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct TodoItemNameLocationEditView_Previews: PreviewProvider {
    @State static var name: String = ""
    @State static var location: String = ""
    @State static var focusIndex: Int = 0
    
    static var previews: some View {
        TodoItemNameLocationEditView(vm: .init(todoItemGroup: nil))
            .preferredColorScheme(.dark)
        TodoItemNameLocationEditView(vm: .init(todoItemGroup: nil))
    }
}
