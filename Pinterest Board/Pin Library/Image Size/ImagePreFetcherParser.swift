//
//  ImagePreFetcherParser.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

public enum ImageParserErrors: Error {
    case unsupportedFormat
    case network(_: Error?)
}

public class ImageSizeFetcherParser {

    public enum Format {
        case jpeg, png, gif, bmp
        
        var minimumSample: Int? {
            switch self {
            case .jpeg: return nil
            case .png:     return 25
            case .gif:     return 11
            case .bmp:    return 29
            }
        }
        
        internal init(fromData data: Data) throws {
            // Evaluate the format of the image
            var length = UInt16(0)
            (data as NSData).getBytes(&length, range: NSRange(location: 0, length: 2))
            switch CFSwapInt16(length) {
            case 0xFFD8:    self = .jpeg
            case 0x8950:    self = .png
            case 0x4749:    self = .gif
            case 0x424D:     self = .bmp
            default:        throw ImageParserErrors.unsupportedFormat
            }
        }
    }
    
    public let format: Format
    
    public let size: CGSize
    
    public let sourceURL: URL
    
    init?(sourceURL: URL, _ data: Data) throws {
        let imageFormat = try ImageSizeFetcherParser.Format(fromData: data)
        guard let size = try ImageSizeFetcherParser.imageSize(format: imageFormat, data: data) else {
            return nil
        }
        self.format = imageFormat
        self.size = size
        self.sourceURL = sourceURL
    }
    
    private static func imageSize(format: Format, data: Data) throws -> CGSize? {
        if let minLen = format.minimumSample, data.count <= minLen {
            return nil
        }
        
        switch format {
        case .bmp:
            var length: UInt16 = 0
            (data as NSData).getBytes(&length, range: NSRange(location: 14, length: 4))
            
            var w: UInt32 = 0; var h: UInt32 = 0;
            (data as NSData).getBytes(&w, range: (length == 12 ? NSMakeRange(18, 4) : NSMakeRange(18, 2)))
            (data as NSData).getBytes(&h, range: (length == 12 ? NSMakeRange(18, 4) : NSMakeRange(18, 2)))
            
            return CGSize(width: Int(w), height: Int(h))
            
        case .png:
            var w: UInt32 = 0; var h: UInt32 = 0;
            (data as NSData).getBytes(&w, range: NSRange(location: 16, length: 4))
            (data as NSData).getBytes(&h, range: NSRange(location: 20, length: 4))
            
            return CGSize(width: Int(CFSwapInt32(w)), height: Int(CFSwapInt32(h)))
            
        case .gif:
            var w: UInt16 = 0; var h: UInt16 = 0
            (data as NSData).getBytes(&w, range: NSRange(location: 6, length: 2))
            (data as NSData).getBytes(&h, range: NSRange(location: 8, length: 2))
            
            return CGSize(width: Int(w), height: Int(h))
            
        case .jpeg:
            var i: Int = 0
            guard data[i] == 0xFF && data[i+1] == 0xD8 && data[i+2] == 0xFF && data[i+3] == 0xE0 else {
                throw ImageParserErrors.unsupportedFormat
            }
            i += 4
            
            guard data[i+2].char == "J" &&
                data[i+3].char == "F" &&
                data[i+4].char == "I" &&
                data[i+5].char == "F" &&
                data[i+6] == 0x00 else {
                    throw ImageParserErrors.unsupportedFormat
            }
            
            var block_length: UInt16 = UInt16(data[i]) * 256 + UInt16(data[i+1])
            repeat {
                i += Int(block_length)
                if i >= data.count {
                    return nil
                }
                if data[i] != 0xFF {
                    return nil
                }
                if data[i+1] >= 0xC0 && data[i+1] <= 0xC3 {
                    var w: UInt16 = 0; var h: UInt16 = 0;
                    (data as NSData).getBytes(&h, range: NSMakeRange(i + 5, 2))
                    (data as NSData).getBytes(&w, range: NSMakeRange(i + 7, 2))
                    
                    let size = CGSize(width: Int(CFSwapInt16(w)), height: Int(CFSwapInt16(h)) );
                    return size
                } else {
                    i+=2;
                    block_length = UInt16(data[i]) * 256 + UInt16(data[i+1]);
                }
            } while (i < data.count)
            return nil
        }
    }
    
}

private extension Data {
    func subdata(in range: ClosedRange<Index>) -> Data {
        return subdata(in: range.lowerBound ..< range.upperBound + 1)
    }
    
    func substring(in range: ClosedRange<Index>) -> String? {
        return String.init(data: self.subdata(in: range), encoding: .utf8)
    }
}

private extension UInt8 {
    var char: Character {
        return Character(UnicodeScalar(self))
    }
}
