//
//  ViewModel.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 08.09.2022.
//

import Foundation
import Combine

class CharactersViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var characters = [CharacterResult]()
//    let publicKey = "30dfbad9a125327399061356af3e8e70"
//    let privateKey = "da550749d1b076b042d49b372f05c2bf8b09d0e0"
    var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
    }
    
    
    func loadData() {

//        let ts = String(Int(Date().timeIntervalSinceNow))
//        let hash = Utils.md5Hash("\(ts)\(Keys.shared.privateKey)\(Keys.shared.publicKey)")

        guard let url = URL(string: "https://gateway.marvel.com/v1/public/characters?ts=\(Helper.ts)&apikey=\(Keys.shared.publicKey)&hash=\(Helper.hash)") else {
            print("Invalid URL")
            return
        }
        
   // https://gateway.marvel.com/v1/public/characters?ts=0&apikey=30dfbad9a125327399061356af3e8e70&hash=afbdc9d996ff86724a4a8b9b78a36fa6

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.setValue(token, forHTTPHeaderField: key)

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300
                else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CharactersResponse.self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { [weak self] resp in
                self?.characters = resp.charactersData.characterResult
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
