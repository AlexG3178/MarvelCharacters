//
//  ComicsDetailView.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 09.09.2022.
//

import SwiftUI

struct ComicsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsDetailsView(ComicsResult(id: -1, title: "", description: "", img: ImageUrl(path: "", ext: ""), dates: [ComicsDate(type: "", date: "")], characters: Character(items: [])))
    }
}

struct ComicsDetailsView: View {
    
    let selectedComics: ComicsResult
    var viewModel: ComicsDetailsViewModel
    @EnvironmentObject var comicsViewModel: ComicsViewModel
    
    init(_ comics: ComicsResult) {
        self.selectedComics = comics
        self.viewModel = ComicsDetailsViewModel(comics)
    }
    
    var body: some View {
        
        VStack {
            
                        Spacer(minLength: 70)
            
            ZStack(alignment: .top) {
                AsyncImage(url: URL(string: "\(selectedComics.img.path.secure).\(selectedComics.img.ext)"),
                           content: { image in
                    image.resizable()
                }, placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Constants.progressIndicatorColor))
                        .scaleEffect(2)
                })
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .scaledToFill()
                .cornerRadius(10)
                
                VStack(spacing: 20) {
                    Text(selectedComics.title)
                        .fontWeight(.semibold)
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    
                    Text(selectedComics.description ?? "")
                    Spacer()
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 150)
            
            Spacer()
            
            Text("Personages")
                .font(.title2)
                .fontWeight(.semibold)
            
            if comicsViewModel.isLoading {
                loadingSection
            }
            else
            {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        LazyHStack (spacing: 10) {
                            ForEach(viewModel.charactersData.sorted(by: >), id: \.key, content: { name, url in
                                
                                VStack {
                                    AsyncImage(url: URL(string: url.secure),
                                               content: { image in
                                        image.resizable()
                                    }, placeholder: {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Constants.progressIndicatorColor))
                                            .scaleEffect(2)
                                    })
                                    .frame(width: 170, height: 170)
                                    .cornerRadius(10)
                                    
                                    Text(name)
                                        .font(.headline)
                                        .frame(maxWidth: 170)
                                }
                            })
                        }
                    })
            }
            
//            Spacer(minLength: 50)
        }
        .background(Constants.backgroundColor)
        .ignoresSafeArea(edges: .bottom)
//        .navigationBarHidden(true)
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
