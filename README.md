<p align='center'>
  <a href='https://unico.io'>
    <img width='350' src='https://unico.io/wp-content/uploads/2022/07/check.svg'></img>
  </a>
</p>

<h1 align='center'>unico | check - SDK iOS Swift</h1>

<div align='center'>
  
  ### POC de implementação do SDK iOS unico | check em Swift
  
  ![iOS Swift](https://img.shields.io/badge/Swift-white?logo=swift)
  [![CocoaPods compatible](https://img.shields.io/cocoapods/v/unicocheck-ios.svg)](https://cocoapods.org/pods/unicocheck-ios)
  [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
</div>

# 📦 Instalação
## Permissões para utilizar a câmera

Para utilizar o método de abertura de câmera é necessário adicionar as permissões antes de compilar a aplicação no arquivo `Info.plist`.

```
<key>NSCameraUsageDescription</key>
<string>Camera usage description</string>
```

## Inclusão da dependência
### via Cocoapods
Inclua o unicocheck-ios em seu arquivo Podfile:

```rb
pod ‘unicocheck-ios’
```

Em seguida, basta utilizar o comando em seu terminal para instalar as dependências:

```
pod install
```

### via Swift Package Manager (SPM)
Inclua a dependência em seu arquivo Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/acesso-io/unico-check-ios.git", .upToNextMajor(from: "2.3.7"))
]
```

# Utilização da SDK
## Inicialização
Instancie o mabager informando o contexto em questão e sobrescrever os métodos de callback com as lógicas de negócio de sua aplicação implementando a interface `AcessoBioManagerDelegate` dentro da ViewController que deseja utilizar.

```swift
import AcessoBio

class ViewController: UIViewController {
        private var manager: AcessoBioManager?
        
        override func viewDidLoad() {
            super.viewDidLoad()        
            manager = AcessoBioManager(viewController: self)
    }
}

extension ViewController: AcessoBioManagerDelegate {
    func onErrorAcessoBioManager(_ error: ErrorBio!) {
        // your code
    }
    
    func onUserClosedCameraManually() {
        // your code
    }
    
    func onSystemClosedCameraTimeoutSession() {
        // your code
    }
    
    func onSystemChangedTypeCameraTimeoutFaceInference() {
        // your code
    }
}
```

<hr>

### <strong>❗ Todos os métodos do delegate devem ser criados em seu projeto (mesmo que sem nenhuma lógica). Caso contrário, o projeto não compilará com sucesso.</strong>

<hr>

## Configurar modo da câmera Selfie
<p style='font-size: 15px'>
  <b>Modo inteligente (captura automática - Smart Camera)</b>
</p>

Por padrão, o SDK possui o enquadramento inteligente e a captura automática habilitados. Caso utilize este modo de câmera, não é necessário alterar nenhuma configuração.
Caso as configurações da câmera tenham sido alteradas previamente em seu App, é possível restaurá-las através dos métodos `setAutoCapture` e `setSmartFrame`:

```swift
private func configureSmartCamera() {
    manager.setSmartFrame(true)
    manager.setAutoCapture(true)
}
```

<hr>

### <strong>❗ Não é possível implementar o método <span style='font-size: 15px'> `setAutoCapture(autoCapture: true)` </span> com o método <span style='font-size: 15px'> `setSmartFrame(smartFrame: false)`. </span>Ou seja, não é possível manter a captura automática sem o Smart Frame, pois ele é quem realiza o enquadramento inteligente. </strong>

<hr>

<p style='font-size: 15px'>
  <b>Modo normal</b>
</p>
Por padrão, o SDK possui o enquadramento inteligente e a captura automática habilitados. Para utilizar o modo manual ambas as configurações relacionadas a Smart Camera devem ser desligadas através dos métodos `setAutoCapture` e `setSmartFrame`:

```swift
private func configureSmartCamera() {
    manager.setSmartFrame(false)
    manager.setAutoCapture(false)
}
```

<hr>

### <strong>❗Dica </strong> é possivel utilizar o Smart Frame em modo manual. Neste caso, a silhueta é exibida para identificar o enquadramento para então habilitar o botão. Para isto, basta configurar <span style='font-size: 15px'> `setAutoCapture(autoCapture: false)` </span> e <span style='font-size: 15px'> `setSmartFrame(smartFrame: true)`. </span>

<hr>

### Preparar câmera
Para seguir com a abertura da câmera, primeiro deve-se prepará-la utilizando o método `prepareSelfieCamera` com a configuração padrão ou alguma das alterações citadas. Este método recebe como parâmetro a implementação do protocolo `SelfieCameraDelegate` e as credenciais de cadastro (os valores dessas informações são repassados em seu contato comercial).

```swift
@IBAction func startCamera(_ sender: Any) {
    manager?.build().prepareSelfieCamera(self, config: SDKConfig())
}

```

Quando a câmera estiver preparada, o evento `onCameraReady` é disparado recebendo como parâmetro um objeto do tipo `AcessoBioCameraOpenerDelegate` e efetua a abertura da mesma pelo método `open`.
Caso ocorra algum erro ao preparar a câmera, o evento `onCameraFailed` é disparado. Você deve implementar este método aplicando as regras de negócio de seu App.

```swift
extension ViewController: SelfieCameraDelegate {
    func onCameraReady(_ cameraOpener: AcessoBioCameraOpenerDelegate!) {
        cameraOpener.open(self)
    }
    
    func onCameraFailed(_ message: ErrorPrepare!) {
        // your code
    }
}
```

### Métodos delegates da câmera
Para a configuração do delegate de sucesso e erro da captura da camera, você deve implementar a interface `AcessoBioSelfieDelegate`:


```swift
extension ViewController: AcessoBioSelfieDelegate {
    func onSuccessSelfie(_ result: AcessoBio.SelfieResult!) {
        // your code
    }
    
    func onErrorSelfie(_ errorBio: ErrorBio!) {
        // your code
    }
}
```

Ao efetuar uma captura de imagem com sucesso, este método será invocado e retornará um objeto do tipo `SelfieResult` com 2 atributos: <strong>base64</strong> e <strong>encrypted</strong>.
#### - `base64`: pode ser utilizado caso queira exibir um preview da imagem em seu app;
#### - `encrypted`: deverá ser enviado na chamada de nossas APIs REST do <b>unico check</b>. Para mais informações detalhadas, visite nosso <a href='https://www3.acesso.io/identity/services/v3/docs/'>API Reference</a>.
Ao ocorrer algum erro na captura de imagem, este método será invocado e retornará um objeto do tipo `ErrorBio`. Para mais informações detalhadas, visite nosso <a href='https://developers.unico.io/docs/check/SDK/iOS/referencias#objeto-errorbio'>Objeto ErrorBio</a>.

## Captura de documentos
<b style='font-size: 15px'>Tipos de documentos possíveis: </b>
- DocumentType.CNH
- DocumentType.CNH_FRENTE
- DocumentType.CNH_VERSO 
- DocumentType.CPF
- DocumentType.RG_FRENTE
- DocumentType.RG_VERSO
- DocumentType.None

### Preparar camêra
Para seguir com a abertura da câmera, primeiro deve-se prepará-la utilizando o método `prepareDocumentCamera`. Este método recebe como parâmetro a implementação do protocolo `DocumentCameraDelegate` e as credenciais de cadastro (os valores dessas informações são repassados em seu contato comercial).

```swift
@IBAction func startDocuments(_ sender: Any) {
    manager?.build().prepareDocumentCamera(self, config: SDKConfig())
}
```

Quando a câmera estiver preparada, o evento `onCameraReadyDocument` é disparado recebendo como parâmetro um objeto do tipo `AcessoBioCameraOpenerDelegate` e efetua a abertura da mesma pelo método `openDocument` passando um dos tipos de documento aceitos e seu delegate `AcessoBioDocumentDelegate`.
Caso ocorra algum erro ao preparar a câmera, o evento `onCameraFailedDocument` é disparado. Você deve implementar este método aplicando as regras de negócio de seu App.


```swift
extension ViewController: DocumentCameraDelegate {
    func onCameraReadyDocument(_ cameraOpener: AcessoBioCameraOpenerDelegate!) {
        cameraOpener.openDocument(DocumentEnums.RG, delegate: self)
    }
    
    func onCameraFailedDocument(_ message: ErrorPrepare!) {
        // your code
    }
}
```

### Métodos delegates da câmera
Para a configuração do delegate de sucesso e erro da captura da camera, você deve implementar a interface `AcessoBioDocumentDelegate`:

```swift
extension ViewController: AcessoBioDocumentDelegate {
    func onSuccessDocument(_ result: AcessoBio.DocumentResult!) {
        // your code
    }
    
    func onErrorDocument(_ errorBio: ErrorBio!) {
        // your code
    }
}
```

Ao efetuar uma captura de imagem com sucesso, este método será invocado e retornará um objeto do tipo `DocumentResult` com 2 atributos: <strong>base64</strong> e <strong>encrypted</strong>.
#### - `base64`: pode ser utilizado caso queira exibir um preview da imagem em seu app;
#### - `encrypted`: deverá ser enviado na chamada de nossas APIs REST do <b>unico check</b>. Para mais informações detalhadas, visite nosso <a href='https://www3.acesso.io/identity/services/v3/docs/'>API Reference</a>.
Ao ocorrer algum erro na captura de imagem, este método será invocado e retornará um objeto do tipo `ErrorBio`. Para mais informações detalhadas, visite nosso <a href='https://developers.unico.io/docs/check/SDK/iOS/referencias#objeto-errorbio'>Objeto ErrorBio</a>.
## Mais informações

Acesse [Site oficial](https://developers.unico.io/docs/check/SDK/iOS/overview)
