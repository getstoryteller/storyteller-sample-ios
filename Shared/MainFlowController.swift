import Foundation
import StorytellerSDK
import SwiftUI
import UIKit

final class MainFlowController {
    // MARK: Lifecycle

    init() {
        storytellerMainDelegate.actionHandler = { [weak self] action in
            switch action {
            case .navigatedToApp(url: let url):
                self?.navigationController?.showAlert(message: "[navigatedToApp] url: \(url)")
            }
        }
    }

    // MARK: Internal

    func present(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        let vc = createMainVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func createMainVC() -> MainViewController {
        let vc = MainViewController(viewModel: mainViewModel)
        vc.title = "Storyteller"
        vc.actionHandler = { [weak self] action in
            switch action {
            case .moveToMultipleLists:
                self?.navigateToMultipleLists()
            case .moveToStoryboardExample:
                self?.navigateToStoryboardExample()
            case .moveToGoogleAdsIntegrationExample:
                self?.navigateToGoogleAdsIntegration()
            case .moveToSwiftUI:
                self?.navigateToSwiftUI()
            }
        }
        mainVC = vc
        return vc
    }

    func navigateToMultipleLists() {
        let vc = MultipleListsViewController(viewModel: multipleListsViewModel, dataSource: multipleListsDataSource)
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToStoryboardExample() {
        let mainStoryboard = UIStoryboard(name: "StoryboardExample", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "StoryboardViewController") as! StoryboardViewController
        navigationController?.pushViewController(viewController, animated: true)
    }

    func navigateToGoogleAdsIntegration() {
        multipleListsViewModel.outputNavigationActionHandler = { [weak self] action in
            switch action {
            case .viewWillDisappear:
                self?.storytellerManager.resetToDefaultStorytellerDelegate()
                self?.multipleListsViewModel.outputNavigationActionHandler = { _ in }
            }
        }
        storytellerManager.setGoogleAdsIntegrationDelegate()
        let vc = MultipleListsViewController(viewModel: multipleListsViewModel, dataSource: multipleListsDataSource)
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToSwiftUI() {
        let swiftUIModel = SwiftUIView.SwiftUIModel()
        let swiftUIViewController = UIHostingController(rootView: SwiftUIView(model: swiftUIModel))
        navigationController?.pushViewController(swiftUIViewController, animated: true)
    }

    // MARK: Private

    private var navigationController: UINavigationController?
    private var mainVC: MainViewController?
    private let storytellerMainDelegate = StorytellerMainDelegate()
    private lazy var storytellerManager: StorytellerManager = {
        StorytellerManager(storyteller: Storyteller.sharedInstance, storytellerDelegate: self.storytellerMainDelegate, storytellerTheme: StorytellerThemes.globalTheme)
    }()
    private lazy var mainViewModel: MainViewModel = {
        MainViewModel(storytellerManager: self.storytellerManager)
    }()
    private lazy var multipleListsViewModel: MultipleListsViewModel = {
        MultipleListsViewModel(storytellerManager: self.storytellerManager)
    }()
    private lazy var multipleListsDataSource: MultipleListsDataSource = {
        MultipleListsDataSource()
    }()
}
