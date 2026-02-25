import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let author: String?
    let images: [URL]
    let rating: Int
    let price: Double
}
