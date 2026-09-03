# 1. Declarative UI 

STATE
  ↓
UI

2. The SwiftUI Mental Model: -

          STATE
            ↓
        body computed
            ↓
         SwiftUI
            ↓
           UI
            ↑
            │
       User interaction
            │
            └──── changes State
            
3. View Composition: -

ProductScreen
 ├── Header
 ├── Search
 ├── Product List
 ├── Product Cell
 └── Footer
 
 
 ProductScreen
    │
    ├── ProductHeaderView
    ├── SearchBarView
    ├── ProductListView
    │       └── ProductRowView
    └── LoadingView
    
    
4. Example of View Composition: -

struct ProductHeaderView: View {

    var body: some View {

        HStack {

            Text("Products")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            Image(systemName: "cart")
        }
        .padding()
    }
}

struct ProductListContent: View {

    let products = [
        "iPhone",
        "MacBook",
        "iPad"
    ]

    var body: some View {

        List(products, id: \.self) { product in

            ProductRowView(
                name: product
            )
        }
    }
}
