//
//  BakeryAPI.swift
//  GEON-PPANG-iOS
//
//  Created by JEONGEUN KIM on 2023/07/17.
//

import Foundation

import Moya

final class BakeryAPI {
    
    typealias BookmarkResponse = GeneralResponse<BookmarkResponseDTO>
    
    static let shared: BakeryAPI = BakeryAPI()
    
    private init() { }
    
    var bakeryListProvider = MoyaProvider<BakeryService>(plugins: [MoyaLoggingPlugin()])
    
    public private(set) var bakeryList: GeneralArrayResponse<BakeryListResponseDTO>?
    public private(set) var bakeryDetail: GeneralResponse<BakeryDetailResponseDTO>?
    public private(set) var writtenRiviews: GeneralResponse<WrittenReviewsResponseDTO>?
    public private(set) var bookmark: BookmarkResponse?
    
    // MARK: - GET
    
    func getBakeryList(sort: String, isHard: Bool, isDessert: Bool, isBrunch: Bool, completion: @escaping (GeneralArrayResponse<BakeryListResponseDTO>?) -> Void) {
        bakeryListProvider.request(.bakeryList(sort: sort, isHard: isHard, isDessert: isDessert, isBrunch: isBrunch)) { result in
            switch result {
            case let .success(response):
                do {
                    self.bakeryList = try response.map(GeneralArrayResponse<BakeryListResponseDTO>.self)
                    guard let bakeryList = self.bakeryList else { return }
                    completion(bakeryList)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getBakeryDetail(bakeryID: Int, completion: @escaping (GeneralResponse<BakeryDetailResponseDTO>?) -> Void) {
        bakeryListProvider.request(.fetchBakeryDetail(bakeryID: bakeryID)) { result in
            switch result {
            case let .success(response):
                do {
                    self.bakeryDetail = try response.map(GeneralResponse<BakeryDetailResponseDTO>.self)
                    guard let bakeryDetail = self.bakeryDetail else { return }
                    completion(bakeryDetail)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getWrittenReviews(bakeryID: Int, completion: @escaping (GeneralResponse<WrittenReviewsResponseDTO>?) -> Void) {
        bakeryListProvider.request(.fetchWrittenReviews(bakeryID: bakeryID)) { result in
            switch result {
            case let .success(response):
                do {
                    self.writtenRiviews = try response.map(GeneralResponse<WrittenReviewsResponseDTO>.self)
                    guard let writtenRiviews = self.writtenRiviews else { return }
                    completion(writtenRiviews)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func postBookmark(bakeryID: Int, with request: BookmarkRequestDTO, completion: @escaping (BookmarkResponse?) -> Void) {
        bakeryListProvider.request(.bookmark(bakeryID: bakeryID, request: request)) { result in
            switch result {
            case let .success(response):
                do {
                    self.bookmark = try response.map(BookmarkResponse.self)
                    guard let bookmark = self.bookmark else { return }
                    
                    completion(bookmark)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
}
