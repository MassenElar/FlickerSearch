//
//  ImageSerachViewModel.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//

import Foundation

class ImageSearchViewModel: ObservableObject {
    // MARK: - Properties
    private let webService: ImageSearchWebServiceProtocol
    
    @Published var images: [ImageModel] = []
    @Published var error: String?
    @Published var isLoading: Bool = false
    @Published var selectedImage: ImageModel?
    @Published var errorIsPresented: Bool = false
    
    private var debounceTask: Task<Void, Never>? = nil
    
    // MARK: - Initializer
    init(webService: ImageSearchWebServiceProtocol = ImageSearchWebService()) {
        self.webService = webService
    }
    
    // MARK: - functions
    
    func debounceSearch(searchText: String) async {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            await fetchImages(searchItem: searchText)
        }
    }
    
    func fetchImages(searchItem: String) async {
        Task { @MainActor in
            isLoading = true
            error = nil
            do {
                try await Task.sleep(for: .seconds(0.5))
                self.images = try await webService.fetchImages(searchItem: searchItem).items
                isLoading = false
            } catch (let error) {
                isLoading = false
                self.error = error.localizedDescription
                errorIsPresented = true
                print(error)
            }
        }
    }
}
