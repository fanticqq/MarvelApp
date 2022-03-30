//
//  CharacterDetailsView.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 29.03.2022.
//

import SwiftUI
import Kingfisher

struct CharacterDetailsView: View {
    @StateObject var viewModel: CharacterDetailsViewModel
    
    var body: some View {
        ZStack {
            Color(Asset.Colors.base.color).ignoresSafeArea()
            ScrollView {
                ZStack {
                    VStack(alignment: .center) {
                        KFImage(viewModel.url)
                            .resizable()
                            .scaledToFit()
                            .background(Color(Asset.Colors.foreground.color))

                        Text(viewModel.name)
                            .font(.largeTitle)
                            .foregroundColor(Color(Asset.Colors.textPrimary.color))
                            .padding([.leading, .trailing], 16)

                        Spacer(minLength: 16)

                        Text(viewModel.description ?? "No description for this Hero")
                            .font(.body)
                            .lineLimit(nil)
                            .foregroundColor(Color(Asset.Colors.textPrimary.color))
                            .padding([.leading, .trailing], 16)
                    }
                }
            }
        }
    }
}

struct CharacterDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let character = MarvelCharacter(
            id: 123,
            name: "Capitan Omerica",
            description: "This one is especially interesting. He's just loke Captain America but a bit special",
            thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", fileExtension: "jpg")
        )
        let viewModel = CharacterDetailsViewModel(character: character)
        CharacterDetailsView(viewModel: viewModel)
    }
}
