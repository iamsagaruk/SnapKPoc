//
//  Helper.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

typealias ImageCompletionHandler = (_ image: UIImage?, _ error: NSError?, _ cacheType: CacheType, _ url: URL?) -> Void

extension UIImageView {
    func setImage(with url: String,
                  placeholder: String = "",
                  backgroundColor: UIColor = .clear,
                  contentMode: UIView.ContentMode = .scaleAspectFit,
                  completion: ImageCompletionHandler? = nil) {
        self.backgroundColor = backgroundColor
        self.contentMode = contentMode
        let newUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let imageUrl = URL(string: newUrl)
        let placeholderImage = placeholder == "" ? nil : UIImage(named: placeholder)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: imageUrl, placeholder: placeholderImage) { [weak self] (image, error, cacheType, url) in
            if image != nil {
                self?.contentMode = contentMode
                self?.backgroundColor = backgroundColor
            }
            completion?(image, error, cacheType, url)
        }
    }
}

func getNoInternetErrorModel() -> NetworkErrorModel {
    var errorModel = NetworkErrorModel()
    errorModel.networkStatusType = .noInternet
    return errorModel
}

func getDefaultErrorModel() -> NetworkErrorModel {
    var errorModel = NetworkErrorModel()
    errorModel.networkStatusType = .somethingWentWrong
    return errorModel
}

func addProgressHud() {
    ProgressHUD.show("Loading..", interaction: false)
    ProgressHUD.hudColor(UIColor.black)
    let backColor = UIColor.white.withAlphaComponent(0.5)
    ProgressHUD.backgroundColor(backColor)
    ProgressHUD.spinnerColor(.black)
}

func hideProgressHud() {
    ProgressHUD.dismiss()
}

public func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    do {
        let imageData = try Data(contentsOf: fileURL)
        return UIImage(data: imageData)
    } catch {}
    return nil
}

extension UserDefaults {
    public func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        set(data, forKey: defaultName)
    }
    
    public func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}

extension UIImage {
    public func saveToDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
}
    
    
