//
//  FolderDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

import Foundation
import Alamofire

class FolderDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    // MARK: - 폴더 조회
    func getFolderDataManager(_ viewcontroller: FolderViewController) {
        AF.request(BaseURL + "/folder",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [FolderModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getFolderAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    viewcontroller.getFolderAPIFail()
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 폴더 추가
    func addFolderDataManager(_ parameter: AddFolderInput, _ viewcontroller: FolderViewController) {
        AF.request(BaseURL + "/folder",
                           method: .post,
                           parameters: parameter,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.addFolderAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // MARK: - 폴더명 수정
    func modifyFolderDataManager(_ folderId: Int, _ parameter: AddFolderInput, _ viewcontroller: FolderViewController) {
        AF.request(BaseURL + "/folder/\(folderId)",
                           method: .put,
                           parameters: parameter,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.modifyFolderAPISuccess(result)
            case .failure(let error):
                viewcontroller.modifyFolderAPIFail()
                print(error.responseCode)
            }
        }
    }
    // MARK: - 폴더 삭제
    func deleteFolderDataManager(_ folderId: Int, _ viewcontroller: FolderViewController) {
        AF.request(BaseURL + "/folder/\(folderId)",
                           method: .delete,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.deleteFolderAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // MARK: - 폴더 리스트 조회
    func getFolderListDataManager(_ viewcontroller: SetFolderBottomSheetViewController) {
        AF.request(BaseURL + "/folder/list",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [FolderListModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getFolderListAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    viewcontroller.getFolderListAPIFail()
                default:
                    print(error.responseCode)
                }
            }
        }
    }
}
