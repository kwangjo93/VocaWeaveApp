//
//  VocaDocumentPicker.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/19/24.
//

import UIKit

class VocaDocumentPicker: NSObject, UIDocumentPickerDelegate {
    private weak var viewController: UIViewController?
    private let vocaListVM: VocaListVM

    init(viewController: UIViewController, vocaListVM: VocaListVM) {
        self.viewController = viewController
        self.vocaListVM = vocaListVM
    }

    func showDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = self
        viewController?.present(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else { return }
        if selectedURL.startAccessingSecurityScopedResource() {
            vocaListVM.processDocument(at: selectedURL) { [weak self] rows in
                guard let self = self else { return }
                self.vocaListVM.processAndSaveData(rows)
            }
            selectedURL.stopAccessingSecurityScopedResource()
        } else {
            print("Unable to start accessing security scoped resource.")
        }
    }
}
