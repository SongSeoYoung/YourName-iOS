//
//  ViewControllable+.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

extension ViewControllable {
    func present(
        _ viewControllerToPresent: ViewControllable,
        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        viewControllerToPresent.uiviewController.modalPresentationStyle = modalPresentationStyle
        self.uiviewController.present(viewControllerToPresent.uiviewController, animated: animated, completion: completion)
    }
    
    func dismiss(
        animated: Bool,
        compleition: (() -> Void)? = nil
    ) {
        self.uiviewController.dismiss(animated: animated, completion: compleition)
    }
    
    func push(
        viewController: ViewControllable,
        animated: Bool
    ) {
        self.uiviewController.navigationController?.pushViewController(viewController.uiviewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.uiviewController.navigationController?.popViewController(animated: animated)
    }
}
