//
//  CoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/6/25.
//

import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @EnvironmentObject var coffeeModel: CoffeeViewModel
    @Bindable private var navigator = NavigationManager.nav
    @State private var pressedItemId: Int?
    @State private var searchTerm = ""
    @State private var coffeeItems: [Coffee] = []
    @State private var isShowingCreateCoffeeView = false
    @State public var refreshData: Bool = false
    
    
    var filteredCoffees: [Coffee] {
        guard !searchTerm.isEmpty else { return coffeeItems }
        return coffeeItems.filter {$0.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            VStack {
                HStack {
                    Text("Coffees")
                        .font(.title)
                        .italic()
                        .underline()
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    Button {
                        isShowingCreateCoffeeView = true
                    } label: {
                        Label("Add New Coffee", systemImage: "plus")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.trailing, 30)
                    }
                    .sheet(isPresented: $isShowingCreateCoffeeView) {
                        CreateCoffeeView(refreshData: $refreshData)
                            .environmentObject(coffeeModel)
                    }
                    .padding(.top, 40)
                    .italic()

                }
                
                SearchBar(text: $searchTerm, placeholder: "Search Coffees")

                ScrollView {
                    ForEach(filteredCoffees, id: \.id) { coffee in
                        NavigationLink(destination: CoffeeCard(coffee: coffee)) {
                            CoffeeCardSmall(coffee: coffee)
                                .opacity(pressedItemId == coffee.id ? 0.8 : 1)
                                .contentShape(Rectangle())
                                .pressEvent(onPress: {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        pressedItemId = coffee.id
                                    }
                                }, onRelease: {
                                    withAnimation {
                                        pressedItemId = nil
                                    }
                                })
                        }
                        .buttonStyle(PlainButtonStyle())
                }
                    .padding()
                }
            }
            .addToolbar()
            .addNavigationSupport()
            .task {
                await fetchCoffees()
            }
            .onChange(of: refreshData) { oldValue, newValue in
                print("🔄 onChange triggered: oldValue = \(oldValue), newValue = \(newValue)")
                if newValue {
                    Task {
                        await fetchCoffees()
                    }
                }
            }
        }
    }
    func fetchCoffees() async {
        print("🔄 fetchCoffees() called")
        do {
            coffeeItems = try await coffeeModel.getCoffees(withToken: keychainManager.getToken())
        } catch {
            print("❌ Error getting coffees: \(error)")
        }
        refreshData = false // Reset refreshData after fetching
        print("🔄 refreshData reset to false")
    }
}

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded ({ _ in
                        onRelease()
                    })
            )
    }
}

extension View {
    func pressEvent(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) ->
    some View {
        modifier(ButtonPress(onPress: {onPress()}, onRelease: {onRelease()}))
    }
}

#Preview {
    let keychainManager = KeychainManager()
    let coffeeViewModel = CoffeeViewModel()
    return CoffeeView()
        .environmentObject(keychainManager)
        .environmentObject(coffeeViewModel)
}
