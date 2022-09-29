# UPager

UPager is a pure SwiftUI pager for iOS and macOS.

https://user-images.githubusercontent.com/4135544/192944720-4a84bf42-7273-47fb-9f91-a2d63c3b3799.mov

## Why Use UPager

SwiftUI's TabView supports pagination by attaching the .tabViewStyle() modifier to the TabView, passing in .page like below.

    TabView {
        Text("A")
        Text("B")
        Text("C")
    }
    .tabViewStyle(.page)

However, TabView is limited in that it can only handle a fixed number of items and does not support changes in device orientation.
This package provides a pager supporting infinite number of items and changes in device orientation.

## Prerequisites

* iOS 14.0+, macOS 11.0+

## Installation

You can use Swift Package Manager to add UPager to your project.

1. Add Package Dependency
   * In Xcode, select ``File`` > ``Add Packages...``.
2. Specify the Repository
   * Copy and paste the following into the search/input box.
     ``https://github.com/urarura/UPager.git``
3. Select the Package Products
   * Select ``UPager``, then click Add Package.

## Quick Start

1. Create SwiftUI View

   Select ``File`` > ``New`` > ``File...``, then select ``SwiftUI View``.

2. Import UPager

        import UPager

3. Write View

        struct NewlyCreatedView: View {
            @State private var selection = 1
        
            var body: some View {
                UPager(selection: $selection) { element in
                    Text("\(element)")
                } onPageChanged: { element in
                    print("\(element) is currently displayed.")
                } onReachedToFirst: { element in
                    return Array((element-5)..<element)
                } onReachedToLast: { element in
                    return Array((element+1)...(element+5))
                }
            }
        }

   UPager has the following parameters:
   * **selection**: A binding to the selected element.
   The element must conform to ``Hashable`` protocol.
   * **content**: The view for the specified element.
   * **onPageChanged**: The action to perform when page is changed.
   * **onReachedToFirst**: The action to perform when page is
   reached to the first element of cached elements. You must return array
   consective to the cached elements.
   * **onReachedToLast**: The action to perform when page is
   reached to the last element of cached elements. You must return array
   consective to the cached elements.

Please see the sample project for more details.

## License

UPager is published under the MIT license.
