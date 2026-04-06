import Foundation

struct DivisionStep: Identifiable, Codable {
    let id: UUID
    let partialDividend: Int
    let quotientDigit: Int
    let product: Int
    let remainder: Int
    let bringDownDigit: Int?
    let quotientColumn: Int
    let workStartColumn: Int
    let workWidth: Int

    init(
        id: UUID = UUID(),
        partialDividend: Int,
        quotientDigit: Int,
        product: Int,
        remainder: Int,
        bringDownDigit: Int?,
        quotientColumn: Int,
        workStartColumn: Int,
        workWidth: Int
    ) {
        self.id = id
        self.partialDividend = partialDividend
        self.quotientDigit = quotientDigit
        self.product = product
        self.remainder = remainder
        self.bringDownDigit = bringDownDigit
        self.quotientColumn = quotientColumn
        self.workStartColumn = workStartColumn
        self.workWidth = workWidth
    }
}
