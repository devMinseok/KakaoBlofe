//
//  String.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import UIKit

extension String {
    func htmlToAttributedString(font: UIFont) -> NSAttributedString? {
        let html = String(format:"<span style=\"font-family: '-apple-system', '\(font.fontName)'; font-size: \(font.pointSize);\">%@</span>", self)
        
        guard let data = html.data(using: .utf8) else {
            return NSAttributedString()
        }
        
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding:String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return NSAttributedString()
        }
    }
}
