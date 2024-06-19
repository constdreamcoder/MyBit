//
//  Kingisher+Ext.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/16/24.
//

import UIKit
import Kingfisher

extension KingfisherWrapper where Base: UIImageView {
    func setImageWithAuthHeaders(
        with resource: Resource?,
        placeholder: Placeholder? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(KeychainManager.read(key: .accessToken), forHTTPHeaderField: Headers.authorization.rawValue)
            requestBody.setValue(APIKeys.sesacKey, forHTTPHeaderField: Headers.sesacKey.rawValue)
            return requestBody
        }
                        
        let newOptions: KingfisherOptionsInfo = options ?? [] + [.requestModifier(imageDownloadRequest), .cacheMemoryOnly, .forceRefresh]
        
        self.setImage(
            with: resource,
            placeholder: placeholder,
            options: newOptions,
            progressBlock: progressBlock,
            completionHandler: completionHandler
        )
    }
}
