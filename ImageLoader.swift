//
//  ImageLoader.swift
//  avito-tech-task
//
//  Created by macbook on 28.08.2023.
//

import UIKit

class ImageLoader {
    
    static func DownloadImage(withURL url : URL, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { data , response , error in
            
            let defaultImage = UIImage(systemName: "wifi.slash")!
            
            var downloadImage: UIImage?
            
            if let data = data {
                downloadImage = UIImage(data: data)
            }
            
            if downloadImage != nil {
                print("Success DownLoad Image")
            } else {
                print("Error download Image")
            }
            
            DispatchQueue.main.async {
                completion(downloadImage ?? defaultImage)
            }
            
        }
        dataTask.resume()
    }
}


