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
                        self.profileImage()
                        self.titleView()
                        Spacer(minLength: 16)
                        self.descriptionView()
                        
                        self.comicsTitleView()
                        if self.viewModel.isComicsLoading {
                            self.comicsSkeletonView()
                        } else if self.viewModel.isComicsLoadingFailed {
                            self.comicsLoadingFailedView()
                        } else {
                            self.comicsCollectionView()
                        }
                    }
                }
            }
        }
        .onAppear(perform: self.viewModel.loadComics)
    }
}

private extension CharacterDetailsView {
    func profileImage() -> some View {
        KFImage(viewModel.url)
            .resizable()
            .scaledToFit()
            .background(Color(Asset.Colors.foreground.color))
    }
    
    func titleView() -> some View {
        Text(self.viewModel.name)
            .font(.largeTitle)
            .foregroundColor(Color(Asset.Colors.textPrimary.color))
            .padding([.leading, .trailing], 16)
    }
    
    func descriptionView() -> some View {
        let characterDescription: String
        if let description = self.viewModel.description, !description.isEmpty {
            characterDescription = description
        } else {
            characterDescription = L10n.AvengerDetails.descriptionPlaceholder
        }
        
        return Text(characterDescription)
            .font(.body)
            .lineLimit(nil)
            .foregroundColor(Color(Asset.Colors.textPrimary.color))
            .padding([.leading, .trailing], 16)
    }
    
    func comicsCollectionView() -> some View {
        ScrollView(.horizontal) {
            let layout: [GridItem] = [.init(.fixed(100))]
            LazyHGrid(rows: layout, alignment: .center, spacing: 8) {
                ForEach(self.viewModel.comics) { comic in
                    self.comicCell(for: comic)
                }
            }.padding([.leading, .trailing], 8)
        }
    }
    
    func comicsLoadingFailedView() -> some View {
        let color = Color(Asset.Colors.accent.color)
        return VStack(alignment: .center, spacing: 16) {
            Spacer()
            Text(L10n.LoadingFailed.text)
                .foregroundColor(color)
            Button(L10n.LoadingFailed.action, action: self.viewModel.loadComics)
                .foregroundColor(color)
                .cornerRadius(8)
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(color, lineWidth: 2))
        }
    }
    
    func comicsTitleView() -> some View {
        VStack(alignment: .leading) {
            Spacer(minLength: 20)
            Text("Comics:")
                .font(.title)
                .foregroundColor(Color(Asset.Colors.textPrimary.color))
                .padding([.leading, .trailing], 16)
        }
    }
    
    func comicsSkeletonView() -> some View {
        ScrollView(.horizontal) {
            let layout: [GridItem] = [.init(.fixed(100))]
            LazyHGrid(rows: layout, alignment: .center, spacing: 8) {
                ForEach(0..<4) { _ in
                    Color(Asset.Colors.foreground.color)
                        .frame(width: 100, height: 150)
                        .clipped()
                        .cornerRadius(20)
                }
            }.padding([.leading, .trailing], 8)
        }
        .disabled(true)
    }

    func comicCell(for comic: ComicDisplayItem) -> some View {
        ZStack {
            KFImage(comic.previewURL)
            Color(Asset.Colors.foreground.color).opacity(0.3)
            Text(comic.title)
                .font(.footnote)
                .foregroundColor(Color(Asset.Colors.textPrimary.color))
        }
        .frame(width: 100, height: 150)
        .background(Color(Asset.Colors.foreground.color))
        .clipped()
        .cornerRadius(20)
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
        let viewModel = CharacterDetailsViewModel(character: character, service: ServiceLocator.instance.comicService)
        CharacterDetailsView(viewModel: viewModel)
    }
}
