//
//  TodoRowView.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI

struct TodoListCellView: View {
    var todoItemGroup: TodoItemListModel
    var itemCount: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.theme.background
            VStack(alignment: .center) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(todoItemGroup.name)")
                                .font(.headline)
                            Spacer()
                            Text("Created: \(todoItemGroup.created.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                        }
                        Text("\(todoItemGroup.items.count) item\(todoItemGroup.items.count > 1 ? "s" : "")")
                            .font(.caption)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .border(width: 1, edges: [.bottom], color: Color.theme.secondaryText.opacity(0.8))
    }
}

struct TodoRowView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListCellView(todoItemGroup: dev.todoItemGroup!, itemCount: dev.todoItemGroup!.items.count)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        TodoListCellView(todoItemGroup: dev.todoItemGroup!, itemCount: dev.todoItemGroup!.items.count)
            .previewLayout(.sizeThatFits)
    }
}
