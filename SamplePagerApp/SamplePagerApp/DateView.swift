//
//  DateView.swift
//  SamplePagerApp iOS
//
//  Created by Hiroki Urashima on 2022/09/27.
//

import SwiftUI

struct DateView: View {
    @Binding var selection: DateComponents
    let dateComps: DateComponents
    
    var body: some View {
        VStack {
            let cal = Calendar.current
            let date = cal.date(from: dateComps)!
            
            Text(date, style: .date)
                .font(.largeTitle.bold())
#if os(macOS)
            // For macOS, buttons to change pages are required like below.
            HStack(spacing: 8) {
                Button {
                    selection = cal.dateComponents([.year, .month, .day], from: cal.date(byAdding: .day, value: -1, to: date)!)
                } label: {
                    Label("Prev", systemImage: "arrowtriangle.left.fill").labelStyle(.iconOnly)
                }
                .font(.title3)
                .buttonStyle(.bordered)
                Button {
                    selection = cal.dateComponents([.year, .month, .day], from: cal.date(byAdding: .day, value: +1, to: date)!)
                } label: {
                    Label("Next", systemImage: "arrowtriangle.right.fill").labelStyle(.iconOnly)
                }
                .font(.title3)
                .buttonStyle(.bordered)
            }
#else
            Text("You can swipe in horizontal direction")
                .foregroundColor(.secondary)
#endif
            
            VStack(spacing: 8) {
                Button("Jump to today") {
                    selection = cal.dateComponents([.year, .month, .day], from: Date())
                }
                Button("Jump to 20 days ago") {
                    selection = cal.dateComponents([.year, .month, .day], from: cal.date(byAdding: .day, value: -20, to: date)!)
                }
                Button("Jump to 20 days later") {
                    selection = cal.dateComponents([.year, .month, .day], from: cal.date(byAdding: .day, value: +20, to: date)!)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        let dc = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        DateView(selection: .constant(dc), dateComps: dc)
    }
}
