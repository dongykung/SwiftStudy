//
//  Home.swift
//  URLSession
//
//  Created by 김동경 on 9/30/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct HomeView: View {
    @State private var photos: [Photo] = []
    @State private var page: Int = 1
    @State private var lastFetchedPage: Int = 1
    @State private var isLoading: Bool = false
    
    
    //Paging 하기위한 프로퍼티들
    @State private var activePhotoId: String?
    @State private var lastPhotoId: String?
    
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3)) {
                ForEach(photos) { photo in
                    PhotoCardView(photo: photo)
                }
            }
            .overlay(alignment: .bottom) {
                if isLoading {
                    ProgressView()
                        .offset(y: 30)
                }
            }
            .padding(.bottom, 15)
            .scrollTargetLayout()
            .padding(15)
        }
        .navigationTitle("JSON Parsing")
        .scrollPosition(id: $activePhotoId, anchor: .bottomTrailing)
        .onChange(of: activePhotoId, { oldValue, newValue in
            if newValue == lastPhotoId, !isLoading {
                page += 1
                fetchPhotos()
            }
        })
        .onAppear {
            if photos.isEmpty {
                fetchPhotos()
//                Task {
//                    self.photos = try await fetchPhotos2()
//                }
               // fetchPhotoCombine()
            }
        }
    }
    
    //Fetching Photos as per needs
    func fetchPhotos() {
        Task {
            do {
                if let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=30") {
                    isLoading = true
                    let session = URLSession(configuration: .default)
                    let jsonData = try await session.data(from: url).0
                    let photos = try JSONDecoder().decode([Photo].self, from: jsonData)
                    await MainActor.run {
                        if photos.isEmpty {
                            page = lastFetchedPage
                        } else {
                            self.photos.append(contentsOf: photos)
                            lastPhotoId = self.photos.last?.id
                            lastFetchedPage = page
                        }
                        isLoading = false
                    }
                }
            } catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchPhotos2() async throws -> [Photo] {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=30") else {
            return []
        }
        let data = try await URLSession.shared.data(from: url).0
        let photos = try JSONDecoder().decode([Photo].self, from: data)
        return photos
    }
    
    func fetchPhotoCombine() {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=30") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished successfully")
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { photos in
                self.photos = photos
            }
            .store(in: &self.cancellables)
        
    }
}

struct PhotoCardView: View {
    var photo: Photo
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { proxy in
                AnimatedImage(url: photo.imageURL) {
                    ProgressView()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipShape(.rect(cornerRadius: 12))
            }
            .frame(height: 120)
            
            Text(photo.author)
                .font(.caption)
                .foregroundStyle(.gray)
                .lineLimit(1)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
