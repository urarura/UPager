//
//  NumberView.swift
//  SamplePagerApp iOS
//
//  Created by Hiroki Urashima on 2022/09/27.
//

import SwiftUI

struct NumberView: View {
    @Binding var selection: Int
    let num: Int
    
    var body: some View {
        VStack {
            Text("\(num)")
                .font(.largeTitle.bold())
#if os(macOS)
            // For macOS, buttons to change pages are required like below.
            HStack(spacing: 8) {
                Button(action: { selection -= 1 }, label: { Label("Prev", systemImage: "arrowtriangle.left.fill").labelStyle(.iconOnly) })
                    .font(.title3)
                    .buttonStyle(.bordered)
                Button(action: { selection += 1 }, label: { Label("Next", systemImage: "arrowtriangle.right.fill").labelStyle(.iconOnly) })
                    .font(.title3)
                    .buttonStyle(.bordered)
            }
#else
            Text("You can swipe in horizontal direction")
                .foregroundColor(.secondary)
#endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NumberView_Previews: PreviewProvider {
    static var previews: some View {
        NumberView(selection: .constant(1), num: 1)
    }
}
