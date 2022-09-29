//
//  FixedNumbersPagerView.swift
//  SamplePagerApp
//
//  Created by Hiroki Urashima on 2022/09/29.
//

import SwiftUI
import UPager

struct FixedNumbersPagerView: View {
    let items = [1, 2, 3, 4, 5]
    @State private var selection = 3

    var body: some View {
        ZStack(alignment: .topLeading) {

            UPager(items, selection: $selection) { element in
                numberView(number: element)
            }
            
            CloseButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func numberView(number: Int) -> some View {
        VStack {
            Text("\(number)")
                .font(.largeTitle.bold())
#if os(macOS)
            // For macOS, buttons to change pages are required like below.
            HStack(spacing: 8) {
                Button {
                    selection -= 1
                } label: {
                    Label("Prev", systemImage: "arrowtriangle.left.fill").labelStyle(.iconOnly)
                }
                .font(.title3)
                .buttonStyle(.bordered)
                .disabled(items.first == selection)
                Button {
                    selection += 1
                } label: {
                    Label("Next", systemImage: "arrowtriangle.right.fill").labelStyle(.iconOnly)
                }
                .font(.title3)
                .buttonStyle(.bordered)
                .disabled(items.last == selection)
            }
#else
            Text("You can swipe in horizontal direction")
                .foregroundColor(.secondary)
#endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FixedNumbersPagerView_Previews: PreviewProvider {
    static var previews: some View {
        FixedNumbersPagerView()
    }
}
