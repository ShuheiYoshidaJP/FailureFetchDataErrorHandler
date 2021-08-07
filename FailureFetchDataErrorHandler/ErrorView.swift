//
//  ErrorView.swift
//  Qcli
//
//  Created by 吉田周平 on 2021/01/23.
//

import Foundation
import UIKit

class ErrorView: UIView {
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var backLoginVCButton: UIButton!
    @IBOutlet weak var errorTypeLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    var qiitaError: FetchError?
    
    static func make() -> ErrorView {
        let view = UINib(nibName: "ErrorView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as! ErrorView
        return view
    }
    
    @IBAction func backToLoginButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func reload(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func checkSafeArea(viewController: UIViewController) {
        let tabBarController = viewController.tabBarController
        guard let navBarController = viewController.navigationController else { return }
        guard let tabBarHeight = tabBarController != nil ? tabBarController?.tabBar.frame.height : 0 else { return }
        let navBarHeight = navBarController.navigationBar.frame.height
        let height = viewController.view.frame.height - tabBarHeight - navBarHeight
        frame = CGRect(x: 0.0,
                       y: navBarHeight,
                       width: viewController.view.frame.width,
                       height: height)
    }
    
    func setConfig() {
        guard let qiitaError = qiitaError else { return }
        errorTypeLabel.text = qiitaError.message
    }
}
