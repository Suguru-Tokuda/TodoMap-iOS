//
//  TodoRowView.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI

struct TodoRowView: View {
    var todoItemGroup: TodoItemListModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.theme.background
            VStack(alignment: .center) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(todoItemGroup.name)")
                            .font(.headline)
                        Text("\(todoItemGroup.items.count) item\(todoItemGroup.items.count > 1 ? "s" : "")")
                            .font(.caption)
                        Text("Created: \(todoItemGroup.created.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                    }
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
        }
        .frame(minHeight: 70, maxHeight: 70)
        .border(width: 1, edges: [.top, .bottom], color: Color.theme.secondaryText)
    }
}

struct TodoRowView_Previews: PreviewProvider {
    static var previews: some View {
        TodoRowView(todoItemGroup: dev.todoItemGroup!)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        TodoRowView(todoItemGroup: dev.todoItemGroup!)
            .previewLayout(.sizeThatFits)
    }
}
