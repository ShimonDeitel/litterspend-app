import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [LitterEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall on first launch.
    let freeLimit = 35

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("litterspend_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < freeLimit
    }

    func add(_ entry: LitterEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: LitterEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: LitterEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([LitterEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static var seedData: [LitterEntry] {
        [
        LitterEntry(brand: "Brand 1", bags: 1.0, purchaseDate: Date().addingTimeInterval(-86400), changeDate: Date().addingTimeInterval(-86400)),
        LitterEntry(brand: "Brand 2", bags: 2.0, purchaseDate: Date().addingTimeInterval(-172800), changeDate: Date().addingTimeInterval(-172800)),
        LitterEntry(brand: "Brand 3", bags: 3.0, purchaseDate: Date().addingTimeInterval(-259200), changeDate: Date().addingTimeInterval(-259200)),
        LitterEntry(brand: "Brand 4", bags: 4.0, purchaseDate: Date().addingTimeInterval(-345600), changeDate: Date().addingTimeInterval(-345600)),
        LitterEntry(brand: "Brand 5", bags: 5.0, purchaseDate: Date().addingTimeInterval(-432000), changeDate: Date().addingTimeInterval(-432000)),
        LitterEntry(brand: "Brand 6", bags: 6.0, purchaseDate: Date().addingTimeInterval(-518400), changeDate: Date().addingTimeInterval(-518400))
        ]
    }
}
