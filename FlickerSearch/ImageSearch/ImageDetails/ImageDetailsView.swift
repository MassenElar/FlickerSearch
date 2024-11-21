//
//  ImageDetails.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//

import SwiftUI

struct ImageDetailsView: View {
    
    let image: ImageModel
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: image.media.imageLink)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
                }
                .padding(.bottom, 5)
                VStack(alignment: .leading, spacing: 10) {
                    HStackKeyValueText(key: "Title", value: image.title)
                    HStackKeyValueText(key: "Author", value: image.author)
                    HStackKeyValueText(key: "Description", value: image.description )
                    HStackKeyValueText(key: "Published", value: image.publishedDate.toFormattedDate())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding()
        }
    }
    
    func HStackKeyValueText(key: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(key + ":")
                .font(.headline)
                .padding(.trailing, 5)
            Text(value)
                .font(.headline)
                .foregroundStyle(.gray)
        }
        .accessibilityLabel("\(key): \(value)")
        .accessibilityIdentifier(value)
    }
}
