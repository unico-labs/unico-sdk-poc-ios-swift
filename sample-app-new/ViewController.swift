import UIKit
import AcessoBio

class ViewController: UIViewController {

    @IBOutlet weak var selfieCameraConfig: UISegmentedControl!
    private var manager: AcessoBioManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = AcessoBioManager(viewController: self)
    }
    
    private func configureSelfieCamera() {
        var smartCamera = true
        if selfieCameraConfig.selectedSegmentIndex == 0 {
            smartCamera = false
        }
        manager?.setSmartFrame(smartCamera)
        manager?.setAutoCapture(smartCamera)
    }
    
//    MARK: - Button Actions
    
    @IBAction func startCamera(_ sender: Any) {
        configureSelfieCamera()
        manager?.build().prepareSelfieCamera(
            self,
            config: SDKConfig())
    }
    
    @IBAction func startDocuments(_ sender: Any) {
        manager?.build().prepareDocumentCamera(
            self,
            config: SDKConfig())
    }
}

// MARK: - AcessoBioManagerDelegate

extension ViewController: AcessoBioManagerDelegate {
    func onErrorAcessoBioManager(_ error: ErrorBio!) {
        print("\(#fileID) > \(#function)")
    }
    
    func onUserClosedCameraManually() {
        print("\(#fileID) > \(#function)")
    }
    
    func onSystemClosedCameraTimeoutSession() {
        print("\(#fileID) > \(#function)")
    }
    
    func onSystemChangedTypeCameraTimeoutFaceInference() {
        print("\(#fileID) > \(#function)")
    }
}

// MARK: - SelfieCameraDelegate

extension ViewController: SelfieCameraDelegate {
    func onCameraReady(_ cameraOpener: AcessoBioCameraOpenerDelegate!) {
        print("\(#fileID) > \(#function)")
        cameraOpener.open(self)
    }
    
    func onCameraFailed(_ message: ErrorPrepare!) {
        print("\(#fileID) > \(#function) > \(message.desc)")
    }
}

// MARK: - AcessoBioSelfieDelegate

extension ViewController: AcessoBioSelfieDelegate {
    func onSuccessSelfie(_ result: AcessoBio.SelfieResult!) {
        print("\(#fileID) > \(#function)")
    }
    
    func onErrorSelfie(_ errorBio: ErrorBio!) {
        print("\(#fileID) > \(#function)")
    }
}

// MARK: - DocumentCameraDelegate

extension ViewController: DocumentCameraDelegate {
    func onCameraReadyDocument(_ cameraOpener: AcessoBioCameraOpenerDelegate!) {
        cameraOpener.openDocument(DocumentEnums.RG, delegate: self)
    }
    
    func onCameraFailedDocument(_ message: ErrorPrepare!) {
        print("\(#fileID) > \(#function)")
    }
}

// MARK: - AcessoBioDocumentDelegate

extension ViewController: AcessoBioDocumentDelegate {
    func onSuccessDocument(_ result: AcessoBio.DocumentResult!) {
        print("\(#fileID) > \(#function)")
    }
    
    func onErrorDocument(_ errorBio: ErrorBio!) {
        print("\(#fileID) > \(#function)")
    }
}
