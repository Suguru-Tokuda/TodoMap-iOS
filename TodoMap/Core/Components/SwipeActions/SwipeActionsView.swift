//
//  SwipeActionsView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/15/24.
//

import SwiftUI

struct SwipeActionsView<Content: View>: View {
    init(
        actions: [Action],
        @ViewBuilder content: () -> Content
    ) {
        self.actions = actions
        self.content = content()
    }
    var content: Content

    @State var offset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    @State var isDragging = false
    @State var isTriggered = false
    
    let triggerThreshhold: CGFloat = -250
    let expansionThreashhold: CGFloat = -60
    let actions: [Action]
    
    var expansionOffset: CGFloat { CGFloat(actions.count) * -50 }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if !isDragging {
                    startOffset = offset
                    isDragging = true
                }
                
                withAnimation(.interactiveSpring) {
                    if startOffset + value.translation.width <= 0 {
                        offset = startOffset + value.translation.width
                    }
                    
                }
                
                isTriggered = offset < triggerThreshhold
            }
            .onEnded { value in
                isDragging = false
                
                withAnimation {
                    if value.predictedEndTranslation.width < expansionThreashhold && !isTriggered {
                        offset = expansionOffset
                    } else {
                        if let action = actions.last, isTriggered {
                            action.action()
                        }

                        offset = 0
                    }
                }
                
                isTriggered = false
            }
    }

    
    var body: some View {
        content
            .font(.title)
            .offset(x: offset)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay(alignment: .trailing) {
                ZStack(alignment: .trailing) {
                    ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
                        let proportion = CGFloat(actions.count - index)
                        let isDefault = index == actions.count
                        let width: CGFloat = isDefault && isTriggered ? -offset : -offset * proportion / CGFloat(actions.count)
                        ActionButton(action: action,
                                     width: width >= 0 ? width : 0,
                                     isTriggered: isTriggered,
                                     dismiss: {
                            withAnimation {
                                offset = 0
                            }
                        })
                    }
                }
                .animation(.spring, value: isTriggered)
                .modify {
                    if #available(iOS 17.0, *) {
                        $0.onChange(of: isTriggered) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
                }
            }
            .highPriorityGesture(dragGesture)
    }
}

struct ActionButton: View {
    let action: Action
    let width: CGFloat
    let isTriggered: Bool
    var dismiss: () -> Void
    
    var body: some View {
        Button(action: {
            action.action()
            dismiss()
        }, label: {
            action.color
                .overlay(alignment: .leading) {
                    Label(action.name, systemImage: action.systemIcon)
                        .labelStyle(.iconOnly)
                        .padding(.leading)
                }
                .clipped()
                .frame(width: width)
                .animation(.spring, value: isTriggered)
        }).buttonStyle(.plain)
    }
}

#Preview {
    SwipeActionsView(actions: [
        Action(color: .red, name: "Delete", systemIcon: "trash.fill", action: {
            print("I am deleting!")
        }),
        Action(color: .yellow, name: "Move", systemIcon: "folder", action: {
            print("I am moving!")
        }),
        Action(color: .blue, name: "Magic", systemIcon: "sparkles", action: {
            print("I am doing magic!")
        })
    ]) {
        
    }
        .preferredColorScheme(.dark)
}
