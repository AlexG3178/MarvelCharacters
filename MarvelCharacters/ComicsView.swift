//
//  ComicsView.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 09.09.2022.
//

import SwiftUI

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView(CharacterResult(id: -1, name: "", description: "", img: ImageUrl(path: "", ext: ""), comics: CharacterComics(collectionURI: "")))
    }
}

struct ComicsView: View {
    
    let selectedCharacter: CharacterResult
    @ObservedObject var viewModel = ComicsViewModel()
    
    init(_ character: CharacterResult) {
        self.selectedCharacter = character
        viewModel.loadData(character.comics.collectionURI)
//        self.viewModel = ComicsViewModel(character.comics.collectionURI)
    }
    
    var body: some View {
        
        VStack {
            
            Spacer(minLength: 70)
            
            ZStack(alignment: .top) {
                
                AsyncImage(url: URL(string: "\(selectedCharacter.img.path.secure).\(selectedCharacter.img.ext)"),
                           content: { image in
                    image.resizable()
                }, placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .scaleEffect(2)
                })
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width)
                
                VStack(spacing: 20) {
                    Text("\(selectedCharacter.name) comics")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    
                    Text(selectedCharacter.description)
                    Spacer()
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 150)
            
            if viewModel.isLoading {
                loadingSection
            }
            else
            {
                if viewModel.comics.isEmpty {
                    emptyResponseSection
                }
                else
                {
                    List {
                        ForEach(viewModel.comics, id: \.id, content: { comics in
                            NavigationLink(destination: ComicsDetailsView(comics).environmentObject(viewModel), label: {
                                HStack(alignment: .center , spacing: 10, content: {
                                    AsyncImage(url: URL(string: "\(comics.img.path.secure).\(comics.img.ext)"),
                                               content: { image in
                                        image.resizable()
                                    }, placeholder: {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .green))
                                            .scaleEffect(2)
                                    })
                                    .frame(width: 120, height: 120)
                                    .scaledToFit()
                                    //                                    .cornerRadius(10)
                                    
                                    VStack {
                                        Spacer()
                                        Text(comics.title)
                                            .fontWeight(.semibold)
                                            .font(.title3)
                                            .frame(maxWidth: .infinity)
                                        
                                        Spacer()
                                        Text(comics.description ?? "")
                                        Spacer()
                                    }
                                    .lineLimit(2)
                                })
                            })
                        })
                        .listRowBackground(Constants.backgroundColor)
                    }
                    
                    .listStyle(.plain)
                }
            }
        }
        .background(Constants.backgroundColor)
        .ignoresSafeArea(edges: .bottom)
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
