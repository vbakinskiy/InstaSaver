//
//  SaveManager.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit
import Photos

enum Error: LocalizedError {
    case accessDenied
    case unknown
}

final class SaveManger {
    static func saveImage(_ image: UIImage, completion: @escaping (Error?) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                return DispatchQueue.main.async {
                    completion(.accessDenied)
                }
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { saved, error in
                DispatchQueue.main.async {
                    if saved, error == nil {
                        completion(nil)
                    } else {
                        completion(.unknown)
                    }
                }
            }
        }
    }
    
    static func saveVideo(_ remoteUrl: URL, completion: @escaping (Error?) -> ()) {
        downloadVideo(with: remoteUrl) { videoUrl in
            guard let videoUrl = videoUrl else {
                return DispatchQueue.main.async {
                    completion(.unknown)
                }
            }
            writeVideoToLibrary(videoUrl) { error in
                completion(error)
            }
        }
    }
    
    private static func writeVideoToLibrary(_ videoUrl: URL, completion: @escaping (Error?) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                return DispatchQueue.main.async {
                    completion(.accessDenied)
                }
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
            }) { saved, error in
                try? FileManager.default.removeItem(at: videoUrl)
                DispatchQueue.main.async {
                    if saved, error == nil {
                        completion(nil)
                    } else {
                        completion(.unknown)
                    }
                }
            }
        }
    }
    
    private static func downloadVideo(with url: URL, completion: @escaping (URL?) -> ()) {
        URLSession.shared.downloadTask(with: url) { url, response, error in
            guard let tempUrl = url, error == nil else {
                return completion(nil)
            }
            let fileManager = FileManager.default
            let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let videoFileUrl = documentsUrl.appendingPathComponent("video.mp4")
            if fileManager.fileExists(atPath: videoFileUrl.path) {
                try? fileManager.removeItem(at: videoFileUrl)
            }
            do {
                try fileManager.moveItem(at: tempUrl, to: videoFileUrl)
                completion(videoFileUrl)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}

