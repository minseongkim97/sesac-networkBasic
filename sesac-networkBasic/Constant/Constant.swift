//
//  APIKey.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/02.
//

import Foundation

struct APIKey {
    static let BOXOFFICE = "02fbf6622352a47fb2969197a090a8df"
    static let NAVER_ID = "IirldkFAc7PY_rbikdoZ"
    static let NAVER_SECRET = "dSjZXwC6ms"
}

struct EndPoint {
    static let boxOfficeURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
}
