//
//  SampleAppConfig.swift
//  sample-app-new
//
//  Created by Igor Wallace Silva Leite on 20/05/22.

//deverá utilizar os dados configurados da sua apiKey
//

import Foundation
import AcessoBio

class SampleAppConfig : AcessoBioConfigDataSource{
    
    
    func getProjectNumber() -> String {
       return "<YOUR_PROJECT_NUMBER>"
    }
    
    func getProjectId() -> String {
       return "<YOUR_PROJECT_ID>"
    }
    
    func getMobileSdkAppId() -> String {
       return "<YOUR_MOBILE_SDK_APP_ID>"
    }
    
    func getBundleIdentifier() -> String {
       return "<YOUR_MOBILE_BUNDLE_IDENTIFIER>"
    }
    
    func getHostInfo() -> String {
        return "<YOUR_HOST_INFO>"
    }
    
    func getHostKey() -> String {
       return "<YOUR_HOST_KEY>"
    }
}
