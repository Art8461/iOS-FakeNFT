//
//  CollectionNFTPresenter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 02.02.2026.
//

import Foundation

protocol CollectionNFTPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
}

final class CollectionNFTPresenter: CollectionNFTPresenterProtocol {
    weak var view: CollectionNFTViewProtocol?

    func viewDidLoad() { }

    func didTapBack() {
        view?.closeScreen()
    }
}
