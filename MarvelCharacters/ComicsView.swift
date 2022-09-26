//
//  ComicsView.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 09.09.2022.
//

import SwiftUI
import Combine

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
//        viewModel.loadData(character.comics.collectionURI)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
//            Spacer(minLength: 40)
            
            ZStack() {
                AsyncImage(url: URL(string: "\(selectedCharacter.img.path.secure).\(selectedCharacter.img.ext)"),
                           content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                }, placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Constants.progressIndicatorColor))
                        .scaleEffect(2)
                })
                
                VStack(spacing: 0) {
                    Text("\(selectedCharacter.name) comics")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                    ScrollView {
                    Text(selectedCharacter.description)
                            
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    Spacer()
                }
                .frame(height: 249)
                .background(.white.opacity(0.7))
            }
            .frame(height: 250)
            
            .navigationBarItems(trailing:
                                    Picker(
                                        selection: $viewModel.selection,
                                        label: Text("Picker"),
                                        content: {
                                            ForEach(SortBy.allCases) { val in
                                                Text(val.rawValue)
                                                    .tag(val)
                                            }
                                        }
                                    )
                                        .pickerStyle(.segmented)
                                        .accentColor(.red)
                                
                                
                                        .onReceive(Just(viewModel.selection), perform: { _ in
                                            viewModel.sortComics()
                                        })
            )
            
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
                                            .progressViewStyle(CircularProgressViewStyle(tint: Constants.progressIndicatorColor))
                                            .scaleEffect(2)
                                    })
                                    .frame(width: 120, height: 120)
                                    .scaledToFit()
                                    //                                    .cornerRadius(10)

                                    VStack {
                                        Spacer()
                                        let index = comics.title.firstIndex(of: "#")
                                        Text(comics.title.prefix(upTo: index ?? comics.title.endIndex))
                                            .fontWeight(.semibold)
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)

                                        Spacer()
                                        Text(comics.description ?? "")
                                            .font(.system(size: 13))
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
            .progressViewStyle(CircularProgressViewStyle(tint: Constants.progressIndicatorColor))
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
