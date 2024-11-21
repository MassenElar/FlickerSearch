//
//  ImageSearchView.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//

import SwiftUI

struct ImageSearchView: View {
    
    @ObservedObject private var viewModel = ImageSearchViewModel()
    @State private var isPresented: Bool = false
    @State private var searchText: String = ""
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            content
        }
    }
    
    var content: some View {
        Group {
            ZStack {
                if viewModel.images.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    ScrollView {
                        ZStack {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(viewModel.images) { image in
                                    imageCell(title: image.title, imageUrl: image.media.imageLink)
                                        .onTapGesture {
                                            viewModel.selectedImage = image
                                            self.isPresented.toggle()
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                    if viewModel.isLoading {
                        Color.clear
                            .ignoresSafeArea()
                            .overlay(
                                VStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(2)
                                }
                            )
                    }
                }
            }
            .navigationTitle("Image Search")
            .searchable(text: $searchText, prompt: "Search Images")
            .onChange(of: searchText) { newValue, _  in
                if newValue.isEmpty {
                    viewModel.images = []
                } else {
                    Task {
                        await viewModel.debounceSearch(searchText: newValue)
                    }
                }
            }
            .navigationDestination(isPresented: $isPresented) {
                imageDetailView
            }
        }
        .alert("Error",
               isPresented: $viewModel.errorIsPresented,
               actions: {
                    Button("OK", role: .cancel) {}
                }, message: {
                    Text(viewModel.error ?? "")
                }
        )
    }
    
    func imageCell(title: String, imageUrl: String) -> some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
            }
            Text(title)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
    
    @ViewBuilder
    var imageDetailView: some View {
        if let image = viewModel.selectedImage {
            ImageDetailsView(image: image)
        }
    }
    
    @ViewBuilder
    var emptyStateView: some View {
        VStack {
            Spacer()
            Text("No Result")
                .font(.largeTitle).foregroundStyle(.gray)
            Spacer()
        }
    }
}

#Preview {
    ImageSearchView()
}
