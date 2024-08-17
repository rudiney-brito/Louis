//
//  DetailsViewModel.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//

import Foundation
import CoreData
import Combine

enum DetailViewModelState {
    case idle
    case loading
    case loaded(Record)
    case error(Error)
}

protocol OfferDetailViewModelProtocol {
    var state: CurrentValueSubject<DetailViewModelState, Never> { get set }
    var headerLogo: PassthroughSubject<Data, Never> { get set }
    var coverImage: PassthroughSubject<Data, Never> { get set }
    func getOffer()
}

class OfferDetailViewModel: OfferDetailViewModelProtocol {
    var state = CurrentValueSubject<DetailViewModelState, Never>(.idle)
    var headerLogo = PassthroughSubject<Data, Never>()
    var coverImage = PassthroughSubject<Data, Never>()
    private var subscriptions = Set<AnyCancellable>()
    private let persistentContainer:  NSPersistentContainer
        
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getHeaderLogo(offer: Record) {
        if let headerLogo = offer.headerLogo,
           let url = URL(string: headerLogo) {
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        break
                    }
                } receiveValue: { [weak self] data in
                    offer.headerLogoData = data
                    self?.save()
                    self?.headerLogo.send(data)
                }.store(in: &subscriptions)

        }
    }
    
    func getCoverImage(subscription: Subscription?) {
        if let coverImage = subscription?.coverImage,
           let url = URL(string: coverImage) {
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        break
                    }
                } receiveValue: { [weak self] data in
                    subscription?.coverImageData = data
                    self?.save()
                    self?.coverImage.send(data)
                }.store(in: &subscriptions)

        }
    }
    
    func getOffer() {
        state.send(.loading)
        let request = Customer.fetchRequest()
        
//        if let customer = try? persistentContainer.viewContext.fetch(request).first,
//           let createdAt = customer.metadata?.createdAt,
//           let timeToExpire = customer.metadata?.timeToExpire,
//           createdAt.addingTimeInterval(TimeInterval(integerLiteral: timeToExpire)) >= Date() {
//            state.send(.loaded(customer))
//            return
//        }
        
        guard let url = URL(string: "https://take-home-task-df69e.web.app/takeHome.json") else {
            state.send(.error(NetworkError.invalidURL))
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistentContainer.viewContext
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print("error")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: Record.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("finished")
                    case .failure(let error):
                        print("error \(error)")
                    }
                },
                receiveValue: { [weak self] offer in
                    self?.handleResponse(offer: offer)
                }).store(in: &subscriptions)
    }
    
    private func handleResponse(offer: Record) {
        save()
        state.send(.loaded(offer))
        getHeaderLogo(offer: offer)
        getCoverImage(subscription: offer.subscription)
    }
    
    private func save() {
        try? persistentContainer.viewContext.save()
    }
}
