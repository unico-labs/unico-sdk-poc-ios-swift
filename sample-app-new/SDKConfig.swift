import Foundation
import AcessoBio

final class SDKConfig: AcessoBioConfigDataSource {

    func getBundleIdentifier() -> String {
       "<YOUR_MOBILE_BUNDLE_IDENTIFIER>"
    }
    
    func getHostKey() -> String {
       "<YOUR_HOST_SDKKEY>" //new sdkkey
    }
}
