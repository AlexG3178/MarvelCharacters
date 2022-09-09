//
//  ComicsDetailView.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 09.09.2022.
//

import SwiftUI

struct ComicsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsDetailsView(ComicsResult(id: -1, title: "", description: "", img: ImageUrl(path: "", ext: ""), dates: [ComicsDate(type: "", date: "")]))
    }
}

struct ComicsDetailsView: View {
    
    let selectedComics: ComicsResult
    
    init(_ comics: ComicsResult) {
        self.selectedComics = comics
    }
    
    var body: some View {
        
        VStack {
            
            AsyncImage(url: URL(string: "\(selectedComics.img.path.secure).\(selectedComics.img.ext)"),
                       content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    .scaleEffect(2)
            })
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            .scaledToFit()
            .cornerRadius(10)
            
            VStack {
                Spacer()
                Text(selectedComics.title)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                Text(selectedComics.description ?? "")
                Spacer()
            }
        }
    }
}

