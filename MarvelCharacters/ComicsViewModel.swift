//
//  ComicsViewModel.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 09.09.2022.
//

import Foundation
import Combine

enum SortBy: String, CaseIterable, Identifiable {
    var id: RawValue { rawValue }
    
    case name = "A-Z"
    case date = "Date"
}

class ComicsViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var selection: SortBy = .name
    var comics = [ComicsResult]()
//    let publicKey = "30dfbad9a125327399061356af3e8e70"
//    let privateKey = "da550749d1b076b042d49b372f05c2bf8b09d0e0"
    var cancellables = Set<AnyCancellable>()
        
    func loadData(_ comicsURI: String) {

//        let ts = String(Int(Date().timeIntervalSinceNow))
//        let hash = Utils.md5Hash("\(ts)\(Keys.shared.privateKey)\(Keys.shared.publicKey)")

        guard let url = URL(string: "\(comicsURI.secure)?ts=\(Helper.ts)&apikey=\(Keys.shared.publicKey)&hash=\(Helper.hash)") else {
            print("Invalid URL")
            return
        }

   // https://gateway.marvel.com/v1/public/characters/1011334/comics?ts=0&apikey=30dfbad9a125327399061356af3e8e70&hash=afbdc9d996ff86724a4a8b9b78a36fa6

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
            .decode(type: ComicsResponse.self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { [weak self] resp in
                self?.comics = resp.comicsData?.comicsResult ?? []
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func sortComics() {
        switch selection {
        case .name:
            comics.sort {
                $0.title.lowercased() < $1.title.lowercased()
            }
            
//            comics.sort {
//                let ind = $0.dates.firstIndex { date in
//                    date.type == "focDate"
//                }
//                return Helper.formatIsoDate($0.dates[ind ?? 1].date) < Helper.formatIsoDate($1.dates[ind ?? 1].date)
//            }
        case .date:
            
            comics.sort {
                $0.title.lowercased() > $1.title.lowercased()
            }
//
//            comics.sort {
//                let ind = $0.dates.firstIndex { date in
//                    date.type == "focDate"
//                }
//                return Helper.formatIsoDate($0.dates[ind ?? 1].date) < Helper.formatIsoDate($1.dates[ind ?? 1].date)
//            }
        }
    }
    
    
    
    
//        func loadData(_ comicsURI: String) {
//
//            let ts = String(Int(Date().timeIntervalSinceNow))
//            let hash = Utils.md5Hash("\(ts)\(privateKey)\(publicKey)")
//
//            guard let url = URL(string: "\(comicsURI.secure)?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)") else {
//                print("Invalid URL")
//                return
//            }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
////            request.setValue(token, forHTTPHeaderField: key)
//
//            fetchData(withRequest: request) { returnedData in
//                if let data = returnedData {
//                    guard let response = try? JSONDecoder().decode(ComicsResponse.self, from: data) else { return }
//
//                    DispatchQueue.main.async {
//                        self.comics = response.comicsData?.comicsResult ?? []
//                        self.isLoading = false
//                    }
//                } else {
//                    print("No Data")
//                }
//            }
//        }
        
//        func fetchData(withRequest request: URLRequest, completion: @escaping (_ data: Data?) -> ()) {
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                guard
//                    let data = data,
//                    error == nil,
//                    let response = response as? HTTPURLResponse,
//                    response.statusCode >= 200 && response.statusCode < 300
//                else {
//                    print("Fetch Error")
//                    completion(nil)
//                    return
//                }
//
//                completion(data)
//
//            }.resume()
//        }
}
