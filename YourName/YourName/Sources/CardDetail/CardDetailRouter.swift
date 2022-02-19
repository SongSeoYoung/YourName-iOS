//
//  CardDetailRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/14.
//

import RIBs

protocol CardDetailInteractable: Interactable, CardMoreListener {
    var router: CardDetailRouting? { get set }
    var listener: CardDetailListener? { get set }
}

protocol CardDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CardDetailRouter: ViewableRouter<CardDetailInteractable, CardDetailViewControllable>, CardDetailRouting {
    
    private let cardMoreBuilder: CardMoreBuildable
    private var cardMoreRouter: CardMoreRouting?
    
    private var pageSheetController: PageSheetController<CardMoreContentView>?

    init(
        interactor: CardDetailInteractable,
        viewController: CardDetailViewControllable,
        cardMoreBuildable: CardMoreBuildable
    ) {
        self.cardMoreBuilder = cardMoreBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachCardMore() {
        if self.cardMoreRouter != nil { return }
        let router = self.cardMoreBuilder.build(withListener: self.interactor)
        self.cardMoreRouter = router
        self.attachChild(router)
        guard let pageSheetContentView = router.viewControllable as? CardMoreContentView else { return }
        
        self.pageSheetController = PageSheetController<CardMoreContentView>.init(contentView: pageSheetContentView)
        self.pageSheetController?.onDismiss = { [weak self] _ in
            self?.detachCardMore()
        }
        self.pageSheetController?.show()
    }
    
    func detachCardMore() {
        self.pageSheetController?.close()
        if let router = self.cardMoreRouter {
            self.cardMoreRouter = nil
           
            self.pageSheetController = nil
            self.detachChild(router)
        }
    }
}
