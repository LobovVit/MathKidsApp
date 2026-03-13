import Foundation

struct DivisionStep: Identifiable, Codable {
    let id = UUID()
    let partialDividend: Int
    let quotientDigit: Int
    let product: Int
    let remainder: Int
    let bringDownDigit: Int?
    let quotientColumn: Int
    let workStartColumn: Int
    let workWidth: Int
}
