import SwiftUI
import SwiftData

@main
struct Stat_CheckApp: App {
    @StateObject private var systemMonitor = SystemMonitor()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StatLog.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(systemMonitor)
                .onAppear {
                    systemMonitor.setModelContext(sharedModelContainer.mainContext)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .modelContainer(sharedModelContainer)
        
        MenuBarExtra("Stat Check", systemImage: "chart.bar.fill") {
            MenuBarView()
                .environmentObject(systemMonitor)
        }
        .menuBarExtraStyle(.window)
    }
}
