import Foundation

// MARK: - Protocol

protocol NftDetailPresenter {
    func viewDidLoad()
}

final class NftDetailPresenterImpl: NftDetailPresenter {

    // MARK: - Properties

    weak var view: NftDetailView?
    private let input: NftDetailInput
    private let service: NftService

    // MARK: - Init

    init(input: NftDetailInput, service: NftService) {
        self.input = input
        self.service = service
    }

    // MARK: - Functions

    func viewDidLoad() {
        loadNft()
    }

    private func loadNft() {
        view?.showLoading()
        service.loadNft(id: input.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                assert(Thread.isMainThread)
                self.view?.hideLoading()
                switch result {
                case .success(let nft):
                    let cellModels = nft.images.map { NftDetailCellModel(url: $0) }
                    self.view?.displayCells(cellModels)
                case .failure(let error):
                    let errorModel = self.makeErrorModel(error)
                    self.view?.showError(errorModel)
                }
            }
        }
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        let primary = ErrorAction(
            title: NSLocalizedString("Error.repeat", comment: ""),
            style: .default
        ) { [weak self] in
            self?.loadNft()
        }
        let secondary = ErrorAction(
            title: NSLocalizedString("Закрыть", comment: ""),
            style: .cancel
        ) { }
        return ErrorModel(message: message, primaryAction: primary, secondaryAction: secondary)
    }
}
