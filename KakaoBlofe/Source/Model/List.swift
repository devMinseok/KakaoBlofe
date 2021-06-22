//
//  List.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Foundation

struct List: Codable {
    var documents: [Post]
    var meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case documents
        case meta
    }
}


/** blog
{
    "documents": [
        {
            "blogname": "손대표의꿀팁",
            "contents": "토니<b>안</b> 나이 본명 소속사 결혼 엄마 가게 여자친구 H.O.T.(에이치오티)의 멤버로 1996년 데뷔한 토니<b>안</b>입니다. 토니<b>안</b> 본명은 안승호입니다. 최근 토니<b>안</b>이 사장님 귀는 당나귀 귀에 합류하였습니다. 토니<b>안</b>은 그동안 많은 사업을 해왔습니다. 현재는 AL 엔터테인먼트 소속사를 직접 운영하고 있는데요. AL 엔터테인먼트...",
            "datetime": "2021-06-06T16:58:03.000+09:00",
            "thumbnail": "https://search2.kakaocdn.net/argon/130x130_85_c/D66Fw6jXzZx",
            "title": "토니<b>안</b> 나이 소속사 결혼 엄마",
            "url": "http://mediawikinews.tistory.com/175"
        }
    ],
    "meta": {
        "is_end": false,
        "pageable_count": 800,
        "total_count": 110517820
    }
}
 */


/** cafe
{
    "documents": [
        {
            "cafename": "소울드레서 (SoulDresser)",
            "contents": "아가리좀 닥쳐 니꺼에도 냄새나 혜미야 트젠: 여자는 아무리 빡빡 씻는다고 냄새 <b>안</b>날거같지 혜미야? 니도 씻어도 냄새 난다니까 혜미야? 트젠: 남자들도 그냥 모르는...",
            "datetime": "2021-06-16T13:33:09.000+09:00",
            "thumbnail": "https://search1.kakaocdn.net/argon/130x130_85_c/ISNItrYGKIi",
            "title": "질염?니가 구멍 <b>안</b>까지 빡빡 <b>안</b>씻어서 그렇지 왜 남자...",
            "url": "http://cafe.daum.net/SoulDresser/FLTB/419527"
        }
    ],
    "meta": {
        "is_end": false,
        "pageable_count": 885,
        "total_count": 97338453
    }
}
 */
