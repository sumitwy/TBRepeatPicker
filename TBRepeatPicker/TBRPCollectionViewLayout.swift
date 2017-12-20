//
//  TBRPCollectionViewLayout.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class TBRPCollectionViewLayout: UICollectionViewFlowLayout {
    private var mode: TBRPCollectionMode?
    
    convenience init(mode: TBRPCollectionMode) {
        self.init()
        
        self.mode = mode
        if mode == .Days {
			itemSize = CGSize(width: TBRPDaysItemWidth, height: TBRPDaysItemHeight)
        } else {
			itemSize = CGSize(width: TBRPMonthsItemWidth, height: TBRPMonthsItemHeight)
        }
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }

	override var collectionViewContentSize: CGSize {
        if mode == .Days {
			return CGSize(width: TBRPScreenWidth, height: TBRPDaysCollectionHeight)
        } else {
			return CGSize(width: TBRPScreenWidth, height: TBRPMonthsCollectionHeight)
        }
    }
    
}
