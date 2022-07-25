//
//  SampleAppThemes.swift
//  sample-app-new
//
//  Created by Igor Wallace Silva Leite on 20/05/22.
//

import Foundation
import AcessoBio
import UIKit

class SampleAppThemes: AcessoBioThemeDelegate{
    func getColorBackground() -> Any! {
        return UIColor.black
    }
    
    func getColorBoxMessage() -> Any! {
        return UIColor.red
    }
    
    func getColorTextMessage() -> Any! {
        return UIColor.blue
    }
    
    func getColorBackgroundPopupError() -> Any! {
        return UIColor.brown
    }
    
    func getColorTextPopupError() -> Any! {
        return UIColor.cyan
    }
    
    func getColorBackgroundButtonPopupError() -> Any! {
        return UIColor.darkGray
    }
    
    func getColorTextButtonPopupError() -> Any! {
        return UIColor.purple
    }
    
    func getColorBackgroundTakePictureButton() -> Any! {
        return UIColor.orange
    }
    
    func getColorIconTakePictureButton() -> Any! {
        return UIColor.green
    }
    
    func getColorBackgroundBottomDocument() -> Any! {
        return UIColor.magenta
    }
    
    func getColorTextBottomDocument() -> Any! {
        return UIColor.gray
    }
    
    func getColorSilhouetteSuccess() -> Any! {
        return UIColor.magenta
    }
    
    func getColorSilhouetteError() -> Any! {
        return UIColor.orange
    }
    
    func getColorSilhouetteNeutral() -> Any! {
        return UIColor.red
    }
    
    
}
