//
//  ContentView.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 08.09.2022.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = CharactersViewModel()
    @State private var searchText = ""
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var searchResults: [CharacterData] {
        if searchText.isEmpty {
            return viewModel.characters
        } else {
            return viewModel.characters.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        
        
        if viewModel.isLoading {
            loadingSection
        }
        else
        {
            if viewModel.characters.isEmpty {
                emptyResponseSection
            }
            else
            {
                NavigationView {
                    VStack {
                        Spacer(minLength: 1)
                        .searchable(text: $searchText, prompt: "Search character")
                        List {
                            ForEach(searchResults, id: \.id, content: { character in
                                HStack(alignment: .center , spacing: 10, content: {
                                    AsyncImage(url: URL(string: "\(character.img.path.secure).\(character.img.ext)"),
                                               content: { image in
                                        image.resizable()
                                    }, placeholder: {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .green))
                                            .scaleEffect(2)
                                    })
                                    .frame(width: 120, height: 120)
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    
                                    VStack {
                                        Spacer()
                                        Text(character.name)
                                            .fontWeight(.semibold)
                                            .font(.title2)
                                            .frame(maxWidth: .infinity)
                                        
                                        Spacer()
                                        Text(character.description)
                                        Spacer()
                                    }
                                    .lineLimit(2)
                                })
                            })
                            .listRowBackground(Color("backgroundColor"))
                        }
                        .listStyle(.plain)
                    }
                    .navigationTitle("Marvel Characters")
                    .background(Color("backgroundColor"))
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
}

private var loadingSection: some View {
    ZStack {
        Color(.systemBackground)
            .ignoresSafeArea()
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .green))
            .scaleEffect(4)
    }
}

private var emptyResponseSection: some View {
    
    VStack(spacing: 20) {
        Image(systemName: "airplane.arrival")
            .resizable()
            .frame(width: 100, height: 100)
            .scaledToFit()
        
        Text("There are no flights right now.\n Please try again later.")
            .multilineTextAlignment(.center)
    }
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
}
