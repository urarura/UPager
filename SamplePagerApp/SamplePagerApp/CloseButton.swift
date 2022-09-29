//
//  CloseButton.swift
//  SamplePagerApp iOS
//
//  Created by Hiroki Urashima on 2022/09/27.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Label("Close", systemImage: "xmark")
                .labelStyle(.iconOnly)
                .font(.title)
        }
        .buttonStyle(.borderless)
        .padding()
#if os(iOS)
        .background(Color(uiColor: .systemBackground))
#endif
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton()
    }
}
