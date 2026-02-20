import Foundation

struct PageDto: Dto {
    let page: Int
    let size: Int
    let sortBy: String?

    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size))
        ]
        if let sortBy {
            items.append(URLQueryItem(name: "sortBy", value: sortBy))
        }
        return items
    }
}
