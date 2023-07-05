import UIKit
import AcessoBio

class ViewController: UIViewController {

    @IBOutlet weak var selfieCameraConfig: UISegmentedControl!
    private var manager: AcessoBioManager?
    private lazy var selectedDocument = DocumentEnums.CPF
    private let documents = [("CPF", DocumentEnums.CPF),
                             ("CNH", DocumentEnums.CNH),
                             ("CNH Frente", DocumentEnums.cnhFrente),
                             ("CNH Verso", DocumentEnums.cnhVerso),
                             ("RG", DocumentEnums.RG),
                             ("RG Frente", DocumentEnums.rgFrente),
                             ("RG Verso", DocumentEnums.rgVerso),
                             ("Outros", DocumentEnums.none)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = AcessoBioManager(viewController: self)
        manager?.setTheme(SampleAppThemes())
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
        print("\(#fileID) > \(#function) > \(error.code)")
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
        print("\(#fileID) > \(#function) > \(errorBio.code)")
    }
}

// MARK: - DocumentCameraDelegate

extension ViewController: DocumentCameraDelegate {
    func onCameraReadyDocument(_ cameraOpener: AcessoBioCameraOpenerDelegate!) {
        cameraOpener.openDocument(selectedDocument, delegate: self)
    }
    
    func onCameraFailedDocument(_ message: ErrorPrepare!) {
        print("\(#fileID) > \(#function) > \(message.desc)")
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

 // MARK: - Document Picker - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard component == 0 else { return nil }
        return documents[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard component == 0 else { return }
        selectedDocument = documents[row].1
    }
}

// MARK: - Document Picker - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard component == 0 else { return 0 }
        return documents.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
}
