import AcessoBio
import UIKit

final class SampleAppThemes: AcessoBioThemeDelegate {
    func getColorBackground() -> Any! {
        UIColor.black
    }
    
    func getColorBoxMessage() -> Any! {
        UIColor.red
    }
    
    func getColorTextMessage() -> Any! {
        UIColor.blue
    }
    
    func getColorBackgroundPopupError() -> Any! {
        UIColor.brown
    }
    
    func getColorTextPopupError() -> Any! {
        UIColor.cyan
    }
    
    func getColorBackgroundButtonPopupError() -> Any! {
        UIColor.darkGray
    }
    
    func getColorTextButtonPopupError() -> Any! {
        UIColor.purple
    }
    
    func getColorBackgroundTakePictureButton() -> Any! {
        UIColor.orange
    }
    
    func getColorIconTakePictureButton() -> Any! {
        UIColor.green
    }
    
    func getColorBackgroundBottomDocument() -> Any! {
        UIColor.magenta
    }
    
    func getColorTextBottomDocument() -> Any! {
        UIColor.gray
    }
    
    func getColorSilhouetteSuccess() -> Any! {
        UIColor.magenta
    }
    
    func getColorSilhouetteError() -> Any! {
        UIColor.orange
    }
    
    func getColorSilhouetteNeutral() -> Any! {
        UIColor.red
    }
}
