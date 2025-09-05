import Foundation
import AcessoBio

final class SDKConfig: AcessoBioConfigDataSource {

    func getBundleIdentifier() -> String {
       "com.testeunicomobile.app"
    }
    
    func getHostKey() -> String {
       "r001-6e426b4b-8ffe-4af2-b279-08f94ce3d2e4" //new sdkkey
    }
}
