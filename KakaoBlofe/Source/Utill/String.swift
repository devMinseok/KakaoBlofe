//
//  String.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import UIKit

extension String {
    func htmlToAttributedString(font: UIFont, color: UIColor = .black) -> NSAttributedString? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
            
        let _ = color.getRed(&red, green: &green, blue: &blue, alpha: nil)
            
        let rgb = "rgb(\(red * 255),\(green * 255),\(blue * 255))"
        
        let html = String(format:"<span style=\"font-family: '-apple-system', '\(font.fontName)'; font-size: \(font.pointSize); color: \(rgb);\">%@</span>", self)
        
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
