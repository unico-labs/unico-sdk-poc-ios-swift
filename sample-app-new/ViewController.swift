//
//  ViewController.swift
//  sample-app-new
//
//  Created by Igor Wallace Silva Leite on 18/05/22.
//
import AcessoBio
import UIKit

class ViewController: UIViewController, AcessoBioManagerDelegate, SelfieCameraDelegate,
                      AcessoBioSelfieDelegate,DocumentCameraDelegate,
                      AcessoBioDocumentDelegate{




func onCameraReadyDocument(_ cameraOpener: AcessoBioCameraOpenerDelegate!) {
    cameraOpener.openDocument(
           DocumentEnums.RG,
           delegate: self
       )
}

func onCameraFailedDocument(_ message: ErrorPrepare!) {
    print("errosCameraDocument")
}

func onSuccessDocument(_ result: DocumentResult!) {
    print("onSucess")
    
}

func onErrorDocument(_ errorBio: ErrorBio!) {
   print("onErrorDocument")
}

    func onCameraReady(_ cameraOpener: AcessoBioCameraOpenerDelegate!) {
        cameraOpener.open(self)   }
    
    func onCameraFailed(_ message: ErrorPrepare!) {
      print("errosCamera")
    }
    
    func onSuccessSelfie(_ result: SelfieResult!) {
//         print("onSucess")
//        NSLog("%@", result.encrypted)
    }
    
    func onErrorSelfie(_ errorBio: ErrorBio!) {

        print("onError")
    }
//
    
    
    
    
    
    
    func onErrorAcessoBioManager(_ error: ErrorBio!) {
        print("onErrorAcessoBioManager")
    }
    
    func onUserClosedCameraManually() {
        print("onErrorUserClosedCameraManually")
    }
    
    func onSystemClosedCameraTimeoutSession() {
        print("onErroronSystemClosedCameraTimeoutSession")
    }
    
    func onSystemChangedTypeCameraTimeoutFaceInference() {
        print("onErroronSystemChangedTypeCameraTimeoutFaceInference")
    }
    
    
    var unicoCheck: AcessoBioManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        unicoCheck = AcessoBioManager(viewController: self)
        unicoCheck.setTheme(SampleAppThemes())
        
       
    }

    
    
    @IBAction func btnCamera_normal(_ sender: UIButton) {
        unicoCheck.setSmartFrame(false)
           unicoCheck.setAutoCapture(false)

//      opção caso queira usar o arquivo JSON

//        unicoCheck.build().prepareSelfieCamera(self, jsonConfigName:
//               "sample-app-new")

//      opção caso queira usar o AppConfig
        unicoCheck.build().prepareSelfieCamera(self, config: SampleAppConfig())
    }
    
    
    @IBAction func btnCameraSmart(_ sender: UIButton) {
        unicoCheck.setSmartFrame(true)
           unicoCheck.setAutoCapture(true)
//      opção caso queira usar o arquivo JSON
//        unicoCheck.build().prepareSelfieCamera(self, jsonConfigName:
//               "sample-app-new")

//      opção caso queira usar o AppConfig
        unicoCheck.build().prepareSelfieCamera(self, config: SampleAppConfig())
    }
    

    @IBAction func btnDocuments(_ sender: UIButton) {
//      opção caso queira usar o arquivo JSON
//        unicoCheck.build().prepareSelfieCamera(self, jsonConfigName:
//               "sample-app-new")

//      opção caso queira usar o AppConfig
        unicoCheck.build().prepareDocumentCamera(self, config: SampleAppConfig())
    }
    
    
}

