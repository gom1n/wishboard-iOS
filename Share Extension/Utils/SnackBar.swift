//
//  SnackBar.swift
//  Share Extension
//
//  Created by gomin on 2023/09/25.
//

import Foundation
import UIKit

class SnackBar {
    
    static let shared = SnackBar()
    private var isShowing = false // 스낵바 표시 여부를 추적
    
    let SNACKBAR_HEIGHT = 47
    let SNACKBAR_INTERVAL = 34
    let TRANSLATION_Y: CGFloat
    
    var originView: UIViewController?
    var message: SnackBarMessage?
    
    private init() {
        let translationY = SNACKBAR_HEIGHT + SNACKBAR_INTERVAL
        TRANSLATION_Y = CGFloat(-translationY)
    }
    
    // MARK: Views
    let backgroundView = UIView().then{
        $0.backgroundColor = .gray_700
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    var title = UILabel().then{
        $0.textColor = .white
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD2)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: Methods
    func showSnackBar(_ originView: UIViewController, message: SnackBarMessage) {
        
        // 스낵바가 이미 표시 중이면 중복 표시하지 않습니다.
        guard !isShowing else {
            return
        }
        
        isShowing = true // 스낵바가 표시 중임을 표시
        
        self.originView = originView
        self.message = message
        
        setSnackBarUI()
        performAnimation()
        
    }
    /// 스낵바의 UI 설정
    private func setSnackBarUI() {
        setSnackBarContent()
        addSnackBarSubview()
        setSnackBarConstraints()
    }
    /// 스낵바의 문구 내용 설정
    private func setSnackBarContent() {
        guard let message = message else {return}
        
        title.text = message.rawValue
        backgroundView.addSubview(title)
    }
    /// 스낵바의 addSubView
    private func addSnackBarSubview() {
        originView?.view.addSubview(backgroundView)
    }
    /// 스낵바의 제약 조건 설정
    private func setSnackBarConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(SNACKBAR_HEIGHT)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(SNACKBAR_HEIGHT)
        }
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    /// 스낵바의 애니메이션 설정
    private func performAnimation() {
        guard let message = message else {return}
        guard let originView = originView else {return}
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.TRANSLATION_Y)
            } completion: { finished in
                self.performAnimationAtShareExtension()
            }
        }
    }
    /// 링크공유 완료 후 스낵바 실행
    private func performAnimationAtShareExtension() {
        guard let originView = originView else {return}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            originView.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            defer{self.closeSnackBar()}
        }
    }
    /// 스낵바가 닫힐 때 호출되는 메서드
    private func closeSnackBar() {
        isShowing = false // 스낵바가 닫혔음을 표시
        backgroundView.removeFromSuperview() // 스낵바를 화면에서 제거
    }
}

