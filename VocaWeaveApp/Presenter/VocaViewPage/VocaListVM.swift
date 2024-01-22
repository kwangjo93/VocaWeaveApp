//
//  VocaListVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/14/23.
//

import UIKit
import Combine
import SnapKit

final class VocaListVM {
    // MARK: - Property
    private let realmQuery = "myVoca"
    let datamanager: RealmVocaModelType
    let alertPublisher = PassthroughSubject<UIAlertController, Never>()
    let tableViewUpdate = PassthroughSubject<[RealmVocaModel], Never>()
    let whitespacesAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    // MARK: - init
    init(datamanager: RealmVocaModelType) {
        self.datamanager = datamanager
    }
    // MARK: - Helper
    func manageEmptyView(vocaVC: UIViewController,
                         emptyView: EmptyListView,
                         tableView: UITableView) {
        if getMyVocaList().isEmpty {
            tableView.isHidden = true
            vocaVC.view.addSubview(emptyView)
            emptyView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        } else {
            emptyView.removeFromSuperview()
            tableView.isHidden = false
        }
    }

    func processDocument(at url: URL, completion: @escaping ([[String]]) -> Void) {
           do {
               let data = try Data(contentsOf: url)
               if let csvString = String(data: data, encoding: .utf8) {
                   let rows = csvString.components(separatedBy: "\n")
                       .map { $0.components(separatedBy: ",") }
                   completion(rows)
               }
           } catch {
               print("Error processing document: \(error)")
               completion([])
           }
       }

    func processAndSaveData(_ rows: [[String]]) {
        for row in rows where row.count == 2 {
            let sourceText = trimWhitespace(row[0])
            let translatedText = trimWhitespace(row[1])
            guard !sourceText.isEmpty && !translatedText.isEmpty else { continue }
            let vocaModel = RealmVocaModel(sourceText: sourceText,
                                           translatedText: translatedText,
                                           realmQeury: realmQuery)
            if !self.isVocaAlreadyExists(vocaModel) {
                addVoca(vocaModel)
                let newVocaList: [RealmVocaModel] = self.getMyVocaList()
                self.tableViewUpdate.send(newVocaList)
            }
        }
    }

    private func trimWhitespace(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed
    }
    // MARK: - Action
    func getMyVocaList() -> [RealmVocaModel] {
        return datamanager.getVocaList(query: realmQuery)
    }

    private func addVoca(_ list: RealmVocaModel) {
        datamanager.makeNewList(list)
    }

    func updateVoca(list: RealmVocaModel, sourceText: String, translatedText: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list,
                                   sourceText: sourceText,
                                   translatedText: translatedText,
                                   isSelected: isSelected)
    }

    func deleteVoca(_ list: RealmVocaModel) {
        datamanager.deleteList(list)
    }

    func nightModeButtonAction() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        window.overrideUserInterfaceStyle = .light
                    } else {
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
            }
        }
    }

    func searchButtonAction(view: UIViewController, searchController: UISearchController) {
        if view.navigationItem.searchController != nil {
            view.navigationItem.searchController = nil
            } else {
                view.navigationItem.searchController = searchController
            }
    }

    func presentActionMenu(view: UIViewController, loadAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "추가하기", message: "선택해주세요.", preferredStyle: .actionSheet)
        let addData = UIAlertAction(title: "단어 추가하기",
                                    style: .default) { _ in self.showAlertWithTextField(newData: nil) }
        let loadData = UIAlertAction(title: "단어 불러오기(.CSV)",
                                     style: .default) { _ in loadAction() }
        let noticeData = UIAlertAction(title: ".CSV 파일 불러오는 방법",
                                       style: .default) { _ in self.presentOnboadingView(view: view) }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addData)
        alert.addAction(loadData)
        alert.addAction(noticeData)
        alert.addAction(cancelAction)
        alertPublisher.send(alert)
    }

    private func presentOnboadingView(view: UIViewController) {
        let onBoardingView = OnboardingVC()
        onBoardingView.modalPresentationStyle = .popover
        onBoardingView.modalTransitionStyle = .crossDissolve
        view.present(onBoardingView, animated: true)
    }
}
// MARK: - Alert - Add, Update Method
extension VocaListVM {
    func showAlertWithTextField(newData: RealmVocaModel?) {
        let alert = configureAlert(newData: newData)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alertPublisher.send(alert)
    }

    private func configureAlert(newData: RealmVocaModel?) -> UIAlertController {
        let alert = UIAlertController(title: "단어와 뜻을 입력해 주세요.", message: nil, preferredStyle: .alert)
        if let newData = newData {
            addTextFields(to: alert, sourceText: newData.sourceText, translatedText: newData.translatedText)
            addAlertAction(to: alert, for: newData)
        } else {
            addPlaceholders(to: alert)
            addAlertAction(for: alert)
        }
        return alert
    }
    private func addTextFields(to alert: UIAlertController, sourceText: String, translatedText: String) {
        alert.addTextField { textField in
            textField.text = sourceText
        }
        alert.addTextField { textField in
            textField.text = translatedText
        }
    }

    private func addPlaceholders(to alert: UIAlertController) {
        alert.addTextField { textField in
            textField.placeholder = "단어를 입력해 주세요."
        }
        alert.addTextField { textField in
            textField.placeholder = "뜻을 입력해 주세요."
        }
    }
    private func addAlertAction(to alert: UIAlertController, for newData: RealmVocaModel) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let alert = alert,
                  let sourcetextField = alert.textFields?[0],
                  let sourcetext = sourcetextField.text,
                  let translatedtextField = alert.textFields?[1],
                  let translatedtext = translatedtextField.text else {
                return
            }
            if sourcetext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                translatedtext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.showEmptyTextFieldAlert()
                return
            }
            self.updateVoca(list: newData,
                       sourceText: sourcetext,
                       translatedText: translatedtext,
                       isSelected: newData.isSelected)
            let newVocaList: [RealmVocaModel] = self.getMyVocaList()
            self.tableViewUpdate.send(newVocaList)
        }
        alert.addAction(saveAction)
    }

    private func addAlertAction(for alert: UIAlertController) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let alert = alert,
                  let sourcetextField = alert.textFields?[0],
                  let sourcetext = sourcetextField.text,
                  let translatedtextField = alert.textFields?[1],
                  let translatedtext = translatedtextField.text else {
                return
            }
            if sourcetext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                translatedtext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.showEmptyTextFieldAlert()
                return
            }
            let voca = RealmVocaModel(sourceText: sourcetext, translatedText: translatedtext, realmQeury: realmQuery)
            if !self.isVocaAlreadyExists(voca) {
                self.addVoca(voca)
                let newVocaList: [RealmVocaModel] = self.getMyVocaList()
                self.tableViewUpdate.send(newVocaList)
            } else {
                presentAlertOfDuplication()
            }
        }
        alert.addAction(saveAction)
    }

    private func showEmptyTextFieldAlert() {
        let alert = UIAlertController(title: "경고", message: "단어가 비어 있습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        whitespacesAlertPublisher.send(alert)
    }

  private  func isVocaAlreadyExists(_ voca: RealmVocaModel) -> Bool {
        let existingVocaList: [RealmVocaModel] = getMyVocaList()
        return existingVocaList.contains { $0.sourceText == voca.sourceText
                                        && $0.translatedText == voca.translatedText }
    }

    func setupCell(cell: VocaTableViewCell,
                   sourceText: String,
                   translatedText: String,
                   isSelected: Bool,
                   selectedSegmentIndex: Int) {
        cell.sourceLabel.text = sourceText
        cell.translatedLabel.text = translatedText
        cell.isSelect = isSelected
        cell.selectedSegmentIndex = selectedSegmentIndex
        cell.configureBookmark()
        cell.speakerButtonAction()
        cell.selectionStyle = .none
    }

    private func presentAlertOfDuplication() {
        let alert = UIAlertController(title: "중복",
                                      message: "같은 단어가 이미 있습니다",
                                      preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
        alertPublisher.send(alert)
    }
}
