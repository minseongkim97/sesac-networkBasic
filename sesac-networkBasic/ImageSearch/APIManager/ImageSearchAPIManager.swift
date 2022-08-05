//
//  ImageSearchAPIManager.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

// 클래스 싱글턴 패턴 vs 구조체 싱글턴(사용하지 않음 왜 그럴까?)
class ImageSearchAPIManager {
    
    static let shared = ImageSearchAPIManager()
    
    private init() { }
    
    typealias fetchImageCompletion = (Int, [String]) -> Void
    
    // fetch, request, callRequest, getImage ...> response에 따라 네이밍을 설정해주기도 함
    func fetchImage(query: String, startPage: Int, completion: @escaping fetchImageCompletion) {

        // UTF-8로 인코딩한다. 한글 인코딩
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=\(startPage)"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json["start"].intValue)
                
                let totalCount = json["total"].intValue
                let list = json["items"].arrayValue.map { return $0["link"].stringValue }
                
                completion(totalCount, list)
                
            case .failure(let error):
                print(error)
                completion(0, [])
            }
        }
    }
}
