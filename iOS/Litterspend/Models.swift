import Foundation

struct LitterEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var brand: String
    var bags: Double
    var purchaseDate: Date
    var changeDate: Date

    init(id: UUID = UUID(), createdAt: Date = Date(), brand: String = "", bags: Double = 0, purchaseDate: Date = Date(), changeDate: Date = Date()) {
        self.id = id
        self.createdAt = createdAt
        self.brand = brand
        self.bags = bags
        self.purchaseDate = purchaseDate
        self.changeDate = changeDate
    }
}
