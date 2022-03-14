//
//  BaseViewController.swift
//  
//
//  Created by macbook on 09.10.2020.
//

import Foundation
import UIKit

protocol BaseViewControllerProtocol where Self: BaseViewController {
    
    var navigationController: UINavigationController? { get }
    
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {

    fileprivate var visible: Bool = false
    fileprivate lazy var loadingSpinner = { return AlertController.shared.spinner() }()
    fileprivate var isLoadingSpinnerPresented = false
        
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var needToHideNavigationBar: Bool = false
    
    var needToSubscribeToKeyboardEvents: Bool = false
    
    var prefersLargeTitle: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Logger.shared.log("🆕 required init \(self)", type: .lifecycle)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        Logger.shared.log("🆕 override init \(self)", type: .lifecycle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitle
        }
        subscribeToNetworkStateChanges()
        subscribeToApplicationEvents()
        Logger.shared.log("viewDidLoad \(self)", type: .lifecycle)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needToHideNavigationBar {
            self.navigationController?.setNavigationBarHidden(true, animated: animated) //hide
        }
        if needToSubscribeToKeyboardEvents {
            self.subscribeToKeyboardChanges()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.visible = true
        
		Logger.shared.log("viewDidAppear \(self)", type: .lifecycle)
		
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromNetworkStateChanges()
        if needToHideNavigationBar {
            self.navigationController?.setNavigationBarHidden(false, animated: animated) //show
        }
        
        if needToSubscribeToKeyboardEvents {
            self.unsubscribeFromKeyboardChanges()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.visible = false
        
        Logger.shared.log("viewDidDisappear \(self)", type: .lifecycle)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard UIApplication.shared.applicationState == .inactive else { return }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Logger.shared.log("😱 \(self)", type: .lifecycle)
    }

    deinit {
        unsubscribeFromApplicationEvents()
        Logger.shared.log("🗑 \(self)", type: .lifecycle)
    }
    
    func setupTitle(_ title: String) {
        self.title = title
        self.navigationItem.title = title
    }
    
    func presentLoadingSpinner(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if self.isLoadingSpinnerPresented {
                return
            } else {
                self.isLoadingSpinnerPresented = true
                self.present(self.loadingSpinner, animated: animated, completion: completion)
            }
        }
    }
    
    func dismissLoadingSpinner(animated: Bool = true, completion: (() -> Void)? = nil) { //Use this method!
        DispatchQueue.main.async {
            if self.isLoadingSpinnerPresented {
                self.loadingSpinner.dismiss(animated: animated, completion: {
                    self.isLoadingSpinnerPresented = false
                    completion?()
                })
            } else { completion?() }
        }
    }
    
    // MARK: - Application Events
    final func subscribeToApplicationEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    final func unsubscribeFromApplicationEvents() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        
    }
    
    @objc func applicationDidEnterBackground() {
        
    }
    
    // MARK: - Network
    @objc func networkChanged(notification: NSNotification) {
        // Override
        if !Reachability.isConnectedToNetwork() {
            //if self.noConnectionWireframe.isShowed { return }
            //self.noConnectionWireframe.presentIn(self)
        }
    }
    
    final func subscribeToNetworkStateChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged(notification:)), name: ReachabilityStatusChangedNotification, object: nil)
    }
    
    final func unsubscribeFromNetworkStateChanges() {
        NotificationCenter.default.removeObserver(self, name: ReachabilityStatusChangedNotification, object: nil)
    }
    
    // MARK: - Keyboard
    final func subscribeToKeyboardChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    final func unsubscribeFromKeyboardChanges() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // Override
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        // Override
    }

    // MARK: - Close modal controller
    func showCloseButton() {
        let closeBtn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(BaseViewController.didTapToClose(_:)))
        closeBtn.tintColor = .white

        self.navigationItem.rightBarButtonItems = [closeBtn]
    }

    @objc func didTapToClose(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)

        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Fileprivate

    fileprivate func showError(_ error: NSError) {
        guard error.code != ErrorsFactory.General.processIsBusy.code else {
            return
        }
        
        if (self.presentedViewController as? UIAlertController) != nil {
            return
        }
        if error.code == ErrorsFactory.General.connection.code {
            AlertController.alert("", message: error.localizedDescription, acceptMessage: "OK", acceptBlock: {
            })
            return
        }
        
        AlertController.alert("Error".localized, message: error.localizedDescription, acceptMessage: "OK", acceptBlock: {
        })
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BaseViewController: ErrorsHandlerInterface {

    final func handleError(_ error: NSError?) {
        guard error != nil else {
            return
        }
        DispatchQueue.main.async {
            self.dismissLoadingSpinner {
                if (self.isViewLoaded && self.view.window != nil && self.visible) {
                    self.showError(error!)
                }
            }
        }
    }
    
    final func handleWarning(_ title: String?, message: String?, proceed: @escaping () -> Void, cancel: @escaping () -> Void) {
        DispatchQueue.main.async(execute: { () -> Void in
            AlertController.alert(title ?? "", message: message ?? "", buttons: ["Cancel".localized, "Continue".localized], tapBlock: { (_: UIAlertAction, index: Int) in
                if index == 0 {
                    cancel()
                } else {
                    proceed()
                }
            })
        })
    }
}
