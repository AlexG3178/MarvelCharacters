//
//  CharacterDetailsViewModel.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 10.09.2022.
//

import Foundation
import Combine

class CharactersDetailsViewModel: ObservableObject {
    
//    @Published var isLoading: Bool = true
    @Published var charactersData: [String:String] = [:]
    let publicKey = "30dfbad9a125327399061356af3e8e70"
    let privateKey = "da550749d1b076b042d49b372f05c2bf8b09d0e0"
    var cancellables = Set<AnyCancellable>()
    
    init(_ comicsResult: ComicsResult) {
        loadData(comicsResult)
    }
    
    func loadData(_ comicsResult: ComicsResult) {
        
        let ts = String(Int(Date().timeIntervalSinceNow))
        let hash = Utils.md5Hash("\(ts)\(privateKey)\(publicKey)")
        
        // https://gateway.marvel.com/v1/public/characters?ts=0&apikey=30dfbad9a125327399061356af3e8e70&hash=afbdc9d996ff86724a4a8b9b78a36fa6
        
        for item in comicsResult.characters.items {
            
//            var count: Int = 1
            
            guard let url = URL(string: "\(item.resourceURI.secure)?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)") else {
                print("Invalid URL")
                continue
            }
            
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
                    let path = resp.charactersData.characterResult.first?.img.path ?? ""
                    let ext = resp.charactersData.characterResult.first?.img.ext ?? ""
                    let urlString = "\(path).\(ext)"
                    self?.charactersData[item.name] = urlString
                    
//                    if count >= comicsResult.characters.items.count {
//                        self?.isLoading = false
//                    }
//                    count += 1
                }
                .store(in: &cancellables)
        }
    }
    
    
    
    
    
    
    //    func loadData(_ comicsResult: ComicsResult) {
    //
    //        let ts = String(Int(Date().timeIntervalSinceNow))
    //        let hash = Utils.md5Hash("\(ts)\(privateKey)\(publicKey)")
    //
    //        for item in comicsResult.characters.items {
    //
    //            var count: Int = 1
    //
    //            guard let url = URL(string: "\(item.resourceURI.secure)?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)") else {
    //                print("Invalid URL")
    //                continue
    //            }
    //
    //            var request = URLRequest(url: url)
    //            request.httpMethod = "GET"
    //            //            request.setValue(token, forHTTPHeaderField: key)
    //
    //            fetchData(withRequest: request) { returnedData in
    //                if let data = returnedData {
    //                    guard let resp = try? JSONDecoder().decode(CharactersResponse.self, from: data) else { return }
    //
    //                    DispatchQueue.main.async {
    //                        let path = resp.charactersData.characterResult.first?.img.path ?? ""
    //                        let ext = resp.charactersData.characterResult.first?.img.ext ?? ""
    //                        self.imageUrls.append(path + "." + ext)
    //
    //                        if count >= comicsResult.characters.items.count {
    //                            self.isLoading = false
    //                        }
    //                        count += 1
    //                    }
    //                } else {
    //                    print("No Data")
    //                }
    //            }
    //        }
    //    }
    
    //    func fetchData(withRequest request: URLRequest, completion: @escaping (_ data: Data?) -> ()) {
    //
    //        URLSession.shared.dataTask(with: request) { data, response, error in
    //            guard
    //                let data = data,
    //                error == nil,
    //                let response = response as? HTTPURLResponse,
    //                response.statusCode >= 200 && response.statusCode < 300
    //            else {
    //                print("Fetch Error")
    //                completion(nil)
    //                return
    //            }
    //
    //            completion(data)
    //
    //        }.resume()
    //    }
}
