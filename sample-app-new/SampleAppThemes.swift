import AcessoBio
import UIKit

final class SampleAppThemes: AcessoBioThemeDelegate {
    
    // Fundo geral da aplicação → branco
    func getColorBackground() -> Any! {
        UIColor.white
    }
    
    // Caixa de mensagens → azul claro
    func getColorBoxMessage() -> Any! {
        UIColor.systemBlue.withAlphaComponent(0.1)
    }
    
    // Texto das mensagens → azul principal
    func getColorTextMessage() -> Any! {
        UIColor.systemBlue
    }
    
    // Fundo do popup de erro → branco
    func getColorBackgroundPopupError() -> Any! {
        UIColor.white
    }
    
    // Texto do popup de erro → azul
    func getColorTextPopupError() -> Any! {
        UIColor.systemBlue
    }
    
    // Fundo do botão no popup de erro → azul
    func getColorBackgroundButtonPopupError() -> Any! {
        UIColor.systemBlue
    }
    
    // Texto do botão no popup de erro → branco
    func getColorTextButtonPopupError() -> Any! {
        UIColor.white
    }
    
    // Fundo do botão de tirar foto → azul
    func getColorBackgroundTakePictureButton() -> Any! {
        UIColor.systemBlue
    }
    
    // Ícone do botão de tirar foto → branco
    func getColorIconTakePictureButton() -> Any! {
        UIColor.white
    }
    
    // Fundo da barra inferior de documentos → azul claro
    func getColorBackgroundBottomDocument() -> Any! {
        UIColor.systemBlue.withAlphaComponent(0.15)
    }
    
    // Texto da barra inferior de documentos → azul principal
    func getColorTextBottomDocument() -> Any! {
        UIColor.systemBlue
    }
    
    // Silhueta em caso de sucesso → azul
    func getColorSilhouetteSuccess() -> Any! {
        UIColor.systemBlue
    }
    
    // Silhueta em caso de erro → vermelho
    func getColorSilhouetteError() -> Any! {
        UIColor.systemRed
    }
    
    // Silhueta neutra → cinza claro
    func getColorSilhouetteNeutral() -> Any! {
        UIColor.lightGray
    }
}
