import Foundation
import AcessoBio

final class SDKConfig: AcessoBioConfigDataSource {
    
    func getProjectNumber() -> String {
       "<YOUR_PROJECT_NUMBER>"
    }
    
    func getProjectId() -> String {
       "<YOUR_PROJECT_ID>"
    }
    
    func getMobileSdkAppId() -> String {
       "<YOUR_MOBILE_SDK_APP_ID>"
    }
    
    func getBundleIdentifier() -> String {
       "<YOUR_MOBILE_BUNDLE_IDENTIFIER>"
    }
    
    func getHostInfo() -> String {
        "<YOUR_HOST_INFO>"
    }
    
    func getHostKey() -> String {
       "<YOUR_HOST_KEY>"
    }
}
