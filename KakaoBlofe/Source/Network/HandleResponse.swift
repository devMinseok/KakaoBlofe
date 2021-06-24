//
//  HandleResponse.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Moya
import RxSwift

/// 서버에서 보내주는 오류 문구 파싱용
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func handleResponse() -> Single<Element> {
        return flatMap { response in
            if (200...299) ~= response.statusCode {
                return Single.just(response)
            }

            if let error = try? response.map(ErrorResponse.self) {
                return Single.error(error)
            }

            // Its an error and can't decode error details from server, push generic message
            let genericError = ErrorResponse(errorType: "알 수 없는 오류", message: "")
            return Single.error(genericError)
        }
    }
}
