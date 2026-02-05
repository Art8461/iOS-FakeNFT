import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {
    @discardableResult
    func loadNft(id: String, completion: @escaping NftCompletion) -> NetworkTask?
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    @discardableResult
    func loadNft(id: String, completion: @escaping NftCompletion)  -> NetworkTask?{
        if let nft = storage.getNft(with: id) {
            DispatchQueue.main.async{
                assert(Thread.isMainThread)
                completion(.success(nft))
            }
            return nil
        }

        let request = NFTRequest(id: id)
        return networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
