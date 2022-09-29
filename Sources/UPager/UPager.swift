//
//  UPager.swift
//  UPager
//
//  Created by Hiroki Urashima on 2022/09/29.
//  Copyright © 2022 Hiroki Urashima. All rights reserved.
//

import SwiftUI

/// A view that switches between multiple child views with pagination.
///
/// The following example creates a tab view with inifinite tabs, each presenting the
/// view with a number. The more you swipe to the right view, the more the number is
/// incremented. Similarly, the more you swipe to the left view, the more the number is
/// decremented.
///
///     // selection is defined as Binding<Int> type in this case.
///     UPager(selection: $selection) { element in
///         Text("\(element)")
///     } onPageChanged: { element in
///         print("\(element) is currently displayed.")
///     } onReachedToFirst: { element in
///         return Array((element-5)..<element)
///     } onReachedToLast: { element in
///         return Array((element+1)...(element+5))
///     }
///
/// Use a type comforming ``Hashable`` protocol for selection value such as Int, String,
/// and DateComponents.
///
/// The following example creates a tab view with **fixed** number of elements to show.
///
///     // selection is defined as Binding<Int> type in this case.
///     UPager([1, 2, 3, 4, 5], selection: $selection) { element in
///         Text("\(element)")
///     } onPageChanged: { element in
///         print("\(element) is currently displayed.")
///     }
@available(iOS 14.0, macOS 11.0, *)
public struct UPager<Element, Content>: View where Element: Hashable, Content: View {
    @Environment(\.scenePhase) var scenePhase
    let fixedElements: [Element]
    @State var elements: [Element]
    @Binding var selection: Element
    let content: (Element) -> Content
    let onPageChanged: (Element) -> Void
    let onReachedToFirst: (Element) -> [Element]
    let onReachedToLast: (Element) -> [Element]
    
    @State var updateUI = false
#if os(iOS)
    @State var orientation: UIDeviceOrientation = .portrait
#endif
    
    let supportsLandscape: Bool
    
    /// Creates a pager with fixed number of items
    ///
    /// - Parameter elements: All elements to show
    /// - Parameter selection: A binding to the selected element.
    ///   The element must conform to ``Hashable`` protocol.
    /// - Parameter content: The view for the specified element.
    /// - Parameter onPageChanged: The action to perform when page is changed.
    ///
    public init(_ elements: [Element],
                selection: Binding<Element>,
                content: @escaping (Element) -> Content,
                onPageChanged: @escaping (Element) -> Void
    ) {
        guard elements.contains(selection.wrappedValue) else {
            fatalError("elements should contains selection.")
        }
        
        self.fixedElements = elements
        self._elements = State(initialValue: [selection.wrappedValue])
        self._selection = selection
        self.content = content
        self.onPageChanged = onPageChanged
        self.onReachedToFirst = { elem in
            if let idx = elements.firstIndex(of: elem) {
                return elements.dropLast(elements.count - idx)
            }
            return []
        }
        self.onReachedToLast = { elem in
            if let idx = elements.firstIndex(of: elem) {
                return Array(elements.dropFirst(idx + 1))
            }
            return []
        }
        self.supportsLandscape = Bundle.main.supportsLandscape
    }
    
    /// Creates a pager with inifinite number of items
    ///
    /// - Parameter selection: A binding to the selected element.
    ///   The element must conform to ``Hashable`` protocol.
    /// - Parameter content: The view for the specified element.
    /// - Parameter onPageChanged: The action to perform when page is changed.
    /// - Parameter onReachedToFirst: The action to perform when page is
    ///   reached to the first element of cached elements. You must return array
    ///   consective to the cached elements.
    /// - Parameter onReachedToLast: The action to perform when page is
    ///   reached to the last element of cached elements. You must return array
    ///   consective to the cached elements.
    ///
    public init(selection: Binding<Element>,
         content: @escaping (Element) -> Content,
         onPageChanged: @escaping (Element) -> Void,
         onReachedToFirst: @escaping (Element) -> [Element],
         onReachedToLast: @escaping (Element) -> [Element]
    ) {
        self.fixedElements = []
        self._elements = State(initialValue: [selection.wrappedValue])
        self._selection = selection
        self.content = content
        self.onPageChanged = onPageChanged
        self.onReachedToFirst = onReachedToFirst
        self.onReachedToLast = onReachedToLast
        self.supportsLandscape = Bundle.main.supportsLandscape
    }

    /// The type of view representing the body of this view.
    public var body: some View {
        Group {
#if os(iOS)
            TabView(selection: $selection) {
                ForEach(elements, id: \.self) { element in
                    content(element)
                        .tag(element)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { notif in
                guard supportsLandscape else { return }
                guard let device = notif.object as? UIDevice else { return }
                let orientation = device.orientation
                if ((self.orientation.isPortraitStrictly && orientation.isLandscape) ||
                    (self.orientation.isLandscape && orientation.isPortraitStrictly)) {
                    // if orientation has been changed from portrait to landscape or vice verca
                    self.orientation = orientation
                    
                    let elem = selection
                    self.elements = [elem]
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.updateUI.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.elements = onReachedToFirst(elem) + elements + onReachedToLast(elem)
                            self.updateUI.toggle()
                        }
                    }
                }
            })
            .id(updateUI)
#else
            content(selection)
                .id(selection)
#endif
        }
        .onChange(of: selection) { newSelection in
            if !elements.contains(newSelection) {
                // if selection is out of range,
                // load elements in both directions
                var retryCount = 0
                let maxRetry = 30
                while !elements.contains(newSelection) {
                    if let first = elements.first,
                       let last = elements.last {
                        elements = onReachedToFirst(first) + elements + onReachedToLast(last)
                    }
                    retryCount += 1
                    if retryCount >= maxRetry { break }
                }
                updateUI.toggle()
            }
            
            onPageChanged(newSelection)
            if newSelection == elements.first {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    elements = onReachedToFirst(newSelection) + elements
                    updateUI.toggle()
                }
            }
            if newSelection == elements.last {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    elements = elements + onReachedToLast(newSelection)
                    updateUI.toggle()
                }
            }
        }
        .onChange(of: scenePhase, perform: { newPhase in
            if newPhase == .inactive {
                self.elements = [selection]
                self.updateUI.toggle()
            } else if newPhase == .active {
                expandElementsIfThereIsOneElement()
            }
        })
        .onAppear {
#if os(iOS)
            let orientation = UIDevice.current.orientation
            if orientation.isPortraitStrictly || orientation.isLandscape {
                self.orientation = orientation
            }
#endif

            expandElementsIfThereIsOneElement()
        }
    }
    
    private func expandElementsIfThereIsOneElement() {
        if let elem = elements.first,
           elements.count == 1 {
            self.elements = onReachedToFirst(elem) + elements + onReachedToLast(elem)
            self.updateUI.toggle()
        }
    }
}

#if os(iOS)
@available(iOS 14.0, macOS 11.0, *)
fileprivate extension UIDeviceOrientation {
    var isPortraitStrictly: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return isPortrait
        } else {
            return self == .portrait
        }
    }
}
#endif

@available(iOS 14.0, macOS 11.0, *)
fileprivate extension Bundle {
    var supportsLandscape: Bool {
#if os(iOS)
        let dev = UIDevice.current.userInterfaceIdiom
        
        if dev == .phone || dev == .pad {
            if let orientations = object(forInfoDictionaryKey: "UISupportedInterfaceOrientations") as? [String] {
                return orientations.contains(where: { $0.contains("Landscape") })
            } else {
                return true
            }
        } else {
            return false
        }
#else
        return false
#endif
    }
}

@available(iOS 14.0, macOS 11.0, *)
struct UPager_Previews: PreviewProvider {
    static var previews: some View {
        UPager(selection: .constant(3)) { element in
            Text("\(element)")
        } onPageChanged: { element in

        } onReachedToFirst: { element in
            return []
        } onReachedToLast: { element in
            return []
        }
    }
}
