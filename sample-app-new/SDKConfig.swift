import Foundation
import AcessoBio

final class SDKConfig: AcessoBioConfigDataSource {

    func getBundleIdentifier() -> String {
       "YOUR_BUNDLE_IDENTIFIER"
    }
    
    func getHostKey() -> String {
       "YOUR_SDK_KEY" //new sdkkey
    }
}
