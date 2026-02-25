final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(networkClient: NetworkClient, nftStorage: NftStorage) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    // MARK: - Services

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    var basketService: BasketService {
        BasketServiceImpl(networkClient: networkClient)
    }
    
    var currenciesService: CurrenciesService {
        CurrenciesServiceImpl(networkClient: networkClient)
    }
    
    var paymentService: PaymentService {
        PaymentServiceImpl(networkClient: networkClient)
    }

    var profileService: ProfileServiceProtocol {
        ProfileService(networkClient: networkClient)
    }

    var myNFTsService: MyNFTsServiceProtocol {
        MyNFTsService(networkClient: networkClient)
    }

}

