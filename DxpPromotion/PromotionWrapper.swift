//
//  PromotionWrapper.swift
//  DxpPromotion
//
//  Created by 李标 on 2026/3/11.
//

import Foundation
import DXPNetWorkingManagerLib

@objc public class PromotionWrapper: NSObject {
	
	// 单例，供外界调用
	@objc public static func sharedInstance() -> PromotionWrapper {
		return PromotionWrapper.shared
	}
	
	private static let shared = PromotionWrapper()
	
	// 对内：单例 DxpPromotionConfigManager
	private let configManager = DxpPromotionConfigManager.shareInstance()
	
	@objc public func configureParamsWithUrl(dxpUrl:String, token:String, subsId:String, serviceNumber:String, excludePageNames:Array<String>) {
		configManager.configureParams(withUrl: dxpUrl, token: token, subsId: subsId, serviceNumber: serviceNumber, excludePageNames: excludePageNames)
	}
	
	/// 请求推广数据，通过单例 DxpPromotionConfigManager 获取数据并返回给外层调用者
	/// - Parameter completion: 回调 (success, promotionList, errorMessage, errorCode)
	@objc public func requestPromotionData(completion: @escaping (Bool, [DxpPromotionInfo], String?, String) -> Void) {
		configManager.requestPromotionData { success, promotionList, errorMessage, errorCode in
			completion(success, promotionList, errorMessage, errorCode)
		}
	}
	
	/// 显示推广弹框，通过单例 DxpPromotionConfigManager 调用，3个回调事件透传给外界
	/// - Parameters:
	///   - pageURL: 页面路由标识，由外界传入
	///   - closeBlock: 关闭按钮点击回调 (action)
	///   - primaryButtonBlock: 主按钮点击回调 (action, openType, link)
	///   - secondaryButtonBlock: 次按钮点击回调 (action, openType, link)
	@objc public func showPromotion(pageURL: String,
									showBlock:((Any?) -> Void)? = nil,
									closeBlock: ((String?) -> Void)? = nil,
									primaryButtonBlock: ((String?, String?, String?) -> Void)? = nil,
									secondaryButtonBlock: ((String?, String?, String?) -> Void)? = nil) {
		configManager.showPromotion(pageURL, show: showBlock, close: closeBlock, primaryButtonBlock: primaryButtonBlock, secondaryButtonBlock: secondaryButtonBlock)
	}
}
