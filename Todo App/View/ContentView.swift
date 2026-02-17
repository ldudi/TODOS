//
//  ContentView.swift
//  Todo App
//
//  Created by Labhesh Dudi on 15/02/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var managedObjectContext

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)])
    
    private var todos: FetchedResults<Todo>
    
    @State private var showingAddTodoView: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            List {
                ForEach(todos, id: \.self) { todo in
                    HStack {
                        Text(todo.name ?? "Unknown")
                        Spacer()
                        Text(todo.priority ?? "Unknown")
                    }
                }
                .onDelete(perform: deleteItems)
            } //: LIST
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                                    Button(action: {
                self.showingAddTodoView.toggle()
            }) {
                Image(systemName: "plus")
            } //: ADD BUTTON
                )
        } //: NAVIGATION
        // Present the AddTodoView as a sheet from the NavigationView so it inherits the environment.
        .sheet(isPresented: $showingAddTodoView) {
            AddTodoView().environment(\.managedObjectContext, managedObjectContext)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: managedObjectContext)
            newItem.timestamp = Date()

            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todos[$0] }.forEach(managedObjectContext.delete)
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// MARK: - BODY

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
