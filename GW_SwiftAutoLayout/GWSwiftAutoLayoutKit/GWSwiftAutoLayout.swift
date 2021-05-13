//
//  GWSwiftAutoLayout.swift
//  GW_SwiftAutoLayout
//
//  Created by gw on 2020/9/8.
//  Copyright © 2020 gw. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias GWView = UIView
    typealias GWColor = UIColor
#if swift(>=4.2)
    typealias GWLayoutRelation = NSLayoutConstraint.Relation
    public typealias GWLayoutAttribute = NSLayoutConstraint.Attribute
#else
    typealias GWLayoutRelation = NSLayoutRelation
    public typealias GWLayoutAttribute = NSLayoutAttribute
#endif
    typealias GWConstraintAxis = NSLayoutConstraint.Axis
    typealias GWLayoutPriority = UILayoutPriority

    @available(iOS 9.0, *)
    public typealias GWLayoutGuide = UILayoutGuide
#else
    import AppKit
    public typealias GWView = NSView
    typealias GWColor = NSColor
    typealias GWLayoutRelation = NSLayoutConstraint.Relation
    public typealias GWLayoutAttribute = NSLayoutConstraint.Attribute
    typealias GWLayoutPriority = NSLayoutConstraint.Priority
    typealias GWConstraintAxis = NSLayoutConstraint.Orientation
    @available(OSX 10.11, *)
    public typealias GWLayoutGuide = UILayoutGuide
#endif

private var GWConstraintsKey: UInt8 = 88

private var GWCurrentLayout = "GWCurrentLayout"

enum ConstraintRelation : Int {
    case equal = 1
    case lessThanOrEqual
    case greaterThanOrEqual

    internal var GWLayoutRelation: GWLayoutRelation {
        get {
            switch(self) {
            case .equal:
                return .equal
            case .lessThanOrEqual:
                return .lessThanOrEqual
            case .greaterThanOrEqual:
                return .greaterThanOrEqual
            }
        }
    }
}

extension GWLayoutAttribute{
    func GWGetAttributeValue(_ relation:GWLayoutRelation) -> GWLayoutAttribute {
        switch relation {
            case .lessThanOrEqual:
                return GWLayoutAttribute(rawValue: rawValue+1000) ?? self
            case .greaterThanOrEqual:
                return GWLayoutAttribute(rawValue: rawValue+2000) ?? self
            default:
                return self
        }
    }
}

public protocol GWMainLayout:AnyObject{
    associatedtype GWSelf
}

extension GWLayoutGuide:GWMainLayout{
    public typealias GWSelf = GWLayoutGuide
}

extension GWView:GWMainLayout{
    public typealias GWSelf = GWView
}

public protocol GWLayoutConstraint{}

//MARK:  /////////////////////////////////  布局UI  ////////////////////////////////////
extension GWMainLayout{
    /// 设置当前约束小于等于
    ///
    /// - Returns: 当前视图
    @discardableResult
    public func GWLessOrEqual() -> Self {
       return GWHandleConstraintsRelation(.lessThanOrEqual)
    }

    /// 设置当前约束大于等于
    ///
    /// - Returns: 当前视图
    @discardableResult
    public func GWGreaterOrEqual() -> Self {
       return GWHandleConstraintsRelation(.greaterThanOrEqual)
    }
    /// 设置顶边距(默认相对父视图)
    ///
    /// - Parameter space: 顶边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWTop(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
       let sview = GWGetSuperview()
       #if os(iOS)
       if #available(iOS 11.0, *) , isSafe {
           return self.GWConstraintWithItem(self, attribute: .top, toItem: sview?.safeAreaLayoutGuide, toAttribute: .top, constant: space)
           }
       #endif
       return self.GWConstraintWithItem(self, attribute: .top, toItem: sview, toAttribute: .top, constant: space)
    }
    /// 设置顶边距与指定视图 - 不能是父试图
    ///
    /// - Parameters:
    ///   - space: 顶边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWTop(_ space: CGFloat,toView: AnyObject?) -> Self {
       var toAttribute = GWLayoutAttribute.bottom
       if !GWSameSuperView(view1: toView, view2: self).1 {
           toAttribute = .top
       }
       return self.GWConstraintWithItem(self, attribute: .top, toItem: toView, toAttribute: toAttribute, constant: space)
    }
    /// 设置顶边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量 默认0
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWTopEqual(_ toView: AnyObject?,offset: CGFloat=0,needBaseLine:Bool=false) -> Self {
        let toAttribute = GWLayoutAttribute.top
        return self.GWConstraintWithItem(self, attribute: .top, toItem: toView, toAttribute: toAttribute, constant: offset)
    }


    /// 设置顶边距与指定视图j基线的距离 - 不能是父试图
    /// - Parameters:
    ///   - space: 顶边距
    ///   - toView: 相对视图
    ///   - font: 自身font
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWTopBaseLine(_ space: CGFloat,toView: AnyObject?,font:UIFont?=nil) -> Self {
        let toAttribute = GWLayoutAttribute.lastBaseline
        var offset = space
        if font != nil {
            offset -= font?.GWFontBaseTopY() ?? 0
        }
        return self.GWConstraintWithItem(self, attribute: .top, toItem: toView, toAttribute: toAttribute, constant: space)
    }

    /// 设置底边距(默认相对父视图)
    ///
    /// - Parameter space: 底边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWBottom(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
       let sview = GWGetSuperview()
       #if os(iOS)
           if #available(iOS 11.0, *) , isSafe  {
               return self.GWConstraintWithItem(self, attribute: .bottom, toItem: sview?.safeAreaLayoutGuide, toAttribute: .bottom, constant: 0-space)
           }
       #endif
       return self.GWConstraintWithItem(self, attribute: .bottom, toItem: sview, toAttribute: .bottom, constant: 0-space)
    }
    /// 设置底边距与指定视图 - 不能是父试图
    ///
    /// - Parameters:
    ///   - space: 底边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWBottom(_ space: CGFloat, toView: AnyObject?) -> Self {
       let toAttribute = GWLayoutAttribute.top
       return self.GWConstraintWithItem(self, attribute: .bottom, toItem: toView, toAttribute: toAttribute, constant: space)
    }
    /// 设置底边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量 默认0
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWBottomEqual(_ toView: AnyObject?, offset: CGFloat = 0) -> Self {
       let toAttribute = GWLayoutAttribute.bottom
       return self.GWConstraintWithItem(self, attribute: .bottom, toItem: toView, toAttribute: toAttribute, constant: 0.0 - offset)
    }
    /// 设置左边距(默认相对父视图)
    ///
    /// - Parameter space: 左边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWLeft(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
      let sview = GWGetSuperview()
      #if os(iOS)
          if #available(iOS 11.0, *) , isSafe  {
           return self.GWConstraintWithItem(self, attribute: .left, toItem: sview?.safeAreaLayoutGuide, toAttribute: .left, constant: space)
          }
      #endif
           return self.GWConstraintWithItem(self, attribute: .left, toItem: sview, toAttribute: .left, constant: space)
    }
    /// 设置左边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 左边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWLeft(_ space: CGFloat, toView: AnyObject?) -> Self {
       var toAttribute = GWLayoutAttribute.right
       if !GWSameSuperView(view1: toView, view2: self).1 {
           toAttribute = .left
       }
       return self.GWConstraintWithItem(self, attribute: .left, toItem: toView, toAttribute: toAttribute, constant: space)
    }
    /// 设置左边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量 默认0
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWLeftEqual(_ toView: AnyObject?, offset: CGFloat = 0) -> Self {
       let toAttribute = GWLayoutAttribute.left
       return self.GWConstraintWithItem(self, attribute: .left, toItem: toView, toAttribute: toAttribute, constant: offset)
    }
    /// 设置右边距(默认相对父视图)
    ///
    /// - Parameter space: 右边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWRight(_ space: CGFloat,_ isSafe: Bool = false) -> Self {
       let sview = GWGetSuperview()
       #if os(iOS)
           if #available(iOS 11.0, *) , isSafe  {
               return self.GWConstraintWithItem(self, attribute: .right, toItem: sview?.safeAreaLayoutGuide, toAttribute: .right, constant: 0-space)
           }
       #endif
           return self.GWConstraintWithItem(self, attribute: .right, toItem: sview, toAttribute: .right, constant: 0-space)
    }
    /// 设置右边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 右边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWRight(_ space: CGFloat, toView: AnyObject?) -> Self {
       var toAttribute = GWLayoutAttribute.left
       if !GWSameSuperView(view1: toView, view2: self).1 {
           toAttribute = .right
       }
       return self.GWConstraintWithItem(self, attribute: .right, toItem: toView, toAttribute: toAttribute, constant: 0-space)
    }
    /// 设置右边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量 默认0
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWRightEqual(_ toView: AnyObject?, offset: CGFloat = 0) -> Self {
       let toAttribute = GWLayoutAttribute.right
       return self.GWConstraintWithItem(self, attribute: .right, toItem: toView, toAttribute: toAttribute, constant: 0.0 - offset)
    }
    /// 设置宽度
    ///
    /// - Parameter width: 宽度
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWWidth(_ width: CGFloat) -> Self {
       let toAttribute = GWLayoutAttribute.notAnAttribute
       return self.GWConstraintWithItem(self, attribute: .width, toItem: nil, toAttribute: toAttribute, constant: width)
    }

    /// 设置宽度按比例相等与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - ratio: 比例 默认是1
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWWidthEqual(_ toView: AnyObject?, ratio: CGFloat = 1) -> Self {
       return self.GWConstraintWithItem(self, attribute: .width, toItem: toView, toAttribute: .width, constant: 0, related: .equal, multiplier: ratio)
    }
    /// 设置自动宽度
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWWidthAuto() -> Self {
       #if os(iOS) || os(tvOS)
           if let label = self as? UILabel,label.numberOfLines == 0{
               label.numberOfLines = 1
           }
       #endif
       if self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.width) != nil ||
           self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.width.GWGetAttributeValue(.lessThanOrEqual)) != nil {
           return GWWidth(0).GWGreaterOrEqual()
       }
       let toAttribute = GWLayoutAttribute.notAnAttribute
       return self.GWConstraintWithItem(self, attribute: .width, toItem: nil, toAttribute: toAttribute, constant: 0, related: .greaterThanOrEqual, multiplier: 1)
    }
    /// 设置视图自身高度与宽度的比
    ///
    /// - Parameter ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWHeightWidthRatio(_ ratio: CGFloat) -> Self {
       let toAttribute = GWLayoutAttribute.width
       return self.GWConstraintWithItem(self, attribute: .height, toItem: self, toAttribute: toAttribute, constant: 0, related: .equal, multiplier: ratio)
    }
    /// 设置高度
    ///
    /// - Parameter height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWHeight(_ height: CGFloat) -> Self {
       return self.GWConstraintWithItem(self, attribute: .height, toItem: nil, toAttribute: .height, constant: height)
    }


    /// 设置高度按比例相等与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWHeightEqual(_ toView: AnyObject?, ratio: CGFloat = 1) -> Self {
       return self.GWConstraintWithItem(self, attribute: .height, toItem: toView, toAttribute: .height, constant: 0, related: .equal, multiplier: ratio)
    }

    /// 设置自动高度
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWHeightAuto() -> Self {
       #if os(iOS) || os(tvOS)
           if let label = self as? UILabel {
               if label.numberOfLines != 0 {
                   label.numberOfLines = 0
               }
           }
       #endif
       if self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.height) != nil ||
           self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.height.GWGetAttributeValue(.lessThanOrEqual)) != nil {
           return GWHeight(0).GWGreaterOrEqual()
       }
       let toAttribute = GWLayoutAttribute.notAnAttribute
       return self.GWConstraintWithItem(self, attribute: .height, toItem: nil, toAttribute: toAttribute, constant: 0, related: .greaterThanOrEqual, multiplier: 1)
    }

    /// 设置视图自身宽度与高度的比
    ///
    /// - Parameter ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWWidthHeightRatio(_ ratio: CGFloat) -> Self {
       let toAttribute = GWLayoutAttribute.height
       return self.GWConstraintWithItem(self, attribute: .width, toItem: self, toAttribute: toAttribute, constant: 0, related: .equal, multiplier: ratio)
    }

    /// 设置中心x(默认相对父视图)
    ///
    /// - Parameter x: 中心x偏移量（0与父视图中心x重合）
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWCenterX(_ x: CGFloat) -> Self {
       return self.GWConstraintWithItem(self, attribute: .centerX, toItem: GWGetSuperview(), toAttribute: .centerX, constant: x)
    }

    /// 设置中心x相等并偏移x与指定视图
    ///
    /// - Parameters:
    ///   - toView: 相对视图
    ///   - x: x偏移量（0与指定视图重合）
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWCenterXEqual(_ toView: AnyObject?,_ x: CGFloat = 0) -> Self {
       return self.GWConstraintWithItem(self, attribute: .centerX, toItem: toView, toAttribute: .centerX, constant: x)
    }

    /// 设置中心y偏移(默认相对父视图)
    ///
    /// - Parameter y: 中心y坐标偏移量（0与父视图重合）
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWCenterY(_ y: CGFloat) -> Self {
       return self.GWConstraintWithItem(self, attribute: .centerY, toItem: GWGetSuperview(), toAttribute: .centerY, constant: y)
    }

    /// 设置中心y相等并偏移x与指定视图
      ///
      /// - Parameters:
      ///   - toView: 相对视图
      ///   - y: y偏移量（0与指定视图中心y重合）
      /// - Returns: 返回当前视图
    @discardableResult
    public func GWCenterYEqual(_ toView: AnyObject?,_ y: CGFloat = 0) -> Self {
       return self.GWConstraintWithItem(self, attribute: .centerY, toItem: toView, toAttribute: .centerY, constant: y)
    }

    /// 设置顶部基线边距(默认相对父视图,相当于y)
    ///
    /// - Parameter space: 顶部基线边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWFirstBaseLine(_ space: CGFloat) -> Self {
       return self.GWConstraintWithItem(self, attribute: .firstBaseline, toItem: GWGetSuperview(), toAttribute: .firstBaseline, constant: 0 - space)
    }

    /// 设置顶部基线边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 间距
    ///   - toView: 指定视图
    /// - Returns: 返回当前视图
    //   @discardableResult
    //   public func GWFirstBaseLine(_ space: CGFloat, toView: AnyObject?) -> Self {
    //       var toAttribute = GWLayoutAttribute.lastBaseline
    //       if !GWSameSuperView(view1: toView, view2: self).1 {
    //           toAttribute = .firstBaseline
    //       }
    //       return self.GWConstraintWithItem(self, attribute: .firstBaseline, toItem: toView, toAttribute: toAttribute, constant: 0-space)
    //   }

    /// 设置顶部基线边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWFirstBaseLineEqual(_ toView: AnyObject?, offset: CGFloat = 0) -> Self {
       return self.GWConstraintWithItem(self, attribute: .firstBaseline, toItem: toView, toAttribute: .firstBaseline, constant: offset)
    }

    /// 设置底部基线边距(默认相对父视图)
    ///
    /// - Parameter space: 间隙
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWLastBaseLine(_ space: CGFloat) -> Self {
       return self.GWConstraintWithItem(self, attribute: .lastBaseline, toItem: GWGetSuperview(), toAttribute: .lastBaseline, constant: 0 - space)
    }

    /// 设置底部基线边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 间距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图


    /// 设置底部基线边距与指定视图顶部距离
    ///
    /// - Parameters:
    ///   - space: 间距
    ///   - toView: 相对视图
    ///   - toViewFont: 相对视图font
    /// - Returns:  返回当前视图
    @discardableResult
    public func GWLastBaseLine(_ space: CGFloat, toView: AnyObject? ,toViewFont:UIFont?=nil) -> Self {
        let toAttribute = GWLayoutAttribute.top
        var offset = space
        if toViewFont != nil {
            offset -= toViewFont?.GWFontBaseTopY() ?? 0
        }
       return self.GWConstraintWithItem(self, attribute: .lastBaseline, toItem: toView, toAttribute: toAttribute, constant:0-offset)
    }

    /// 设置底部基线边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWLastBaseLineEqual(_ toView: AnyObject?, offset: CGFloat = 0) -> Self {
       return self.GWConstraintWithItem(self, attribute: .lastBaseline, toItem: toView, toAttribute: .lastBaseline, constant: 0.0 - offset)
    }

    /// 设置中心偏移(默认相对父视图)x,y = 0 与父视图中心重合
    ///
    /// - Parameters:
    ///   - x: 中心x偏移量
    ///   - y: 中心y偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWCenter(_ x: CGFloat, y: CGFloat) -> Self {
       return self.GWCenterX(x).GWCenterY(y)
    }

    /// 设置中心偏移x,y = 0 与指定视图中心重合
    ///
    /// - Parameters:
    ///   - x: 中心x偏移量
    ///   - y: 中心y偏移量
    ///   - toView: 指定视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWCenter(_ x: CGFloat, y: CGFloat, toView: AnyObject?) -> Self {
       return self.GWCenterXEqual(toView, x).GWCenterYEqual(toView, y)
    }

    /// 设置中心相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWCenterEqual(_ toView: AnyObject?) -> Self {
       return self.GWCenterXEqual(toView).GWCenterYEqual(toView)
    }

    /// 设置frame(默认相对父视图)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWFrame(_ left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) -> Self {
       return self.GWLeft(left).GWTop(top).GWWidth(width).GWHeight(height)
    }

    /// 设置frame与指定视图
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - height: 高度
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWFrame(_ left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat, toView: AnyObject?) -> Self {
       return self.GWLeft(left, toView: toView).GWTop(top, toView: toView).GWWidth(width).GWHeight(height)
    }


    /// 设置frame与view相同
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWFrameEqual(_ view: AnyObject?) -> Self {
       return self.GWLeftEqual(view).GWTopEqual(view).GWSizeEqual(view)
    }

    /// 设置bounds与view相同
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWBoundsEqual(_ view: AnyObject?) -> Self {
        return self.GWLeftEqual(view).GWTopEqual(view).GWRightEqual(view).GWBottomEqual(view)
    }

    /// 设置size
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWSize(_ width: CGFloat, height: CGFloat) -> Self {
       return self.GWWidth(width).GWHeight(height)
    }

    /// 设置size相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWSizeEqual(_ view: AnyObject?) -> Self {
       return self.GWWidthEqual(view).GWHeightEqual(view)
    }

    /// 设置frame (默认相对父视图，宽高自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - bottom: 底边距
    ///   - isSafe: 是否使用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWAutoSize(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat, _ isSafe: Bool = false) -> Self {
       return self.GWLeft(left, isSafe).GWTop(top, isSafe).GWRight(right, isSafe).GWBottom(bottom, isSafe)
    }

    /// 设置frame与指定视图（宽高自动）
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - bottom: 底边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWAutoSize(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat, toView: AnyObject?) -> Self {
       return self.GWLeft(left, toView: toView).GWTop(top, toView: toView).GWRight(right, toView: toView).GWBottom(bottom, toView: toView)
    }

    /// 设置frame (默认相对父视图，宽度自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - height: 高度
    ///   - isSafe: 是否使用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWAutoWidth(left: CGFloat, top: CGFloat, right: CGFloat, height: CGFloat, _ isSafe: Bool = false) -> Self {
       return self.GWLeft(left, isSafe).GWTop(top, isSafe).GWRight(right, isSafe).GWHeight(height)
    }

    /// 设置frame与指定视图（宽度自动）
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - height: 高度
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWAutoWidth(left: CGFloat, top: CGFloat, right: CGFloat, height: CGFloat, toView: AnyObject?) -> Self {
       return self.GWLeft(left, toView: toView).GWTop(top, toView: toView).GWRight(right, toView: toView).GWHeight(height)
    }

    /// 设置frame (默认相对父视图，高度自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - bottom: 底边距
    ///   - isSafe: 是否使用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWAutoHeight(left: CGFloat, top: CGFloat, width: CGFloat, bottom: CGFloat, _ isSafe: Bool = false) -> Self {
       return self.GWLeft(left, isSafe).GWTop(top, isSafe).GWWidth(width).GWBottom(bottom, isSafe)
    }

    /// 设置frame与指定视图（自动高度）
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - bottom: 底边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func GWAutoHeight(left: CGFloat, top: CGFloat, width: CGFloat, bottom: CGFloat, toView: AnyObject?) -> Self {
       return self.GWLeft(left, toView: toView).GWTop(top, toView: toView).GWWidth(width).GWBottom(bottom, toView: toView)
    }
}

//MARK: -私有方法-
extension GWMainLayout{

    fileprivate func GWHandleConstraintsRelation(_ relation: GWLayoutRelation) -> Self {
        if let constraints = self.currentConstraint, constraints.relation != relation {
             let tmpConstraints = NSLayoutConstraint(item: constraints.firstItem ?? 0, attribute:  constraints.firstAttribute, relatedBy: relation, toItem: constraints.secondItem, attribute: constraints.secondAttribute, multiplier: constraints.multiplier, constant: constraints.constant)
             if let mainView = GWMainViewConstraint(constraints) {
             mainView.removeConstraint(constraints)
             self.GWRemoveCache(constraint: constraints)
             mainView.addConstraint(tmpConstraints)
             self.GWAddLayoutConstraint(constraints: [tmpConstraints.firstAttribute.GWGetAttributeValue(tmpConstraints.relation).rawValue:tmpConstraints])
             self.currentConstraint = tmpConstraints
            }
        }
        return self
    }

    fileprivate func GWCheckSameAttribute(_ attr:NSLayoutConstraint,
                                        _ item: AnyObject?,
                                        attribute: GWLayoutAttribute,
                                        toAttribute: GWLayoutAttribute,
                                        constant: CGFloat,
                                        related: GWLayoutRelation,
                                        toItem: AnyObject?,
                                        multiplier: CGFloat) -> Bool {
        
        if (attr.firstAttribute == attribute &&
            attr.secondAttribute == toAttribute &&
            attr.firstItem === item &&
            attr.secondItem === toItem &&
            attr.relation == related &&
            attr.multiplier == multiplier) {
            
            attr.constant = constant
            return true
        }
        return false;
    }

    fileprivate func GWConstraintWithItem(_ item: AnyObject?,
                                        attribute: GWLayoutAttribute,
                                        toItem: AnyObject?,
                                        toAttribute: GWLayoutAttribute,
                                        constant: CGFloat,
                                        related: GWLayoutRelation = .equal,
                                        multiplier: CGFloat = 1) -> Self {
        var firstAttribute = attribute
        var twoAttribute = toAttribute
        if toItem == nil {
            twoAttribute = .notAnAttribute
        }else if item == nil {
            firstAttribute = .notAnAttribute
        }
        if let sf = GWGetView(),sf.translatesAutoresizingMaskIntoConstraints {
            sf.translatesAutoresizingMaskIntoConstraints = false
        }
        if let iv = GWGetView(item) {
            iv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        switch firstAttribute {
            case .top:
                if let firstBaseline = self.GWGetCuttentLayoutConstraint(.firstBaseline) {
                    GWRemoveCache(constraint: firstBaseline)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.firstBaseline.rawValue:firstBaseline])
                }
                if let firstBaseline = self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.firstBaseline.GWGetAttributeValue(.lessThanOrEqual)) {
                    GWRemoveCache(constraint: firstBaseline)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.firstBaseline.GWGetAttributeValue(.lessThanOrEqual).rawValue:firstBaseline])
                }
                if let firstBaseline = self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.firstBaseline.GWGetAttributeValue(.greaterThanOrEqual)) {
                    GWRemoveCache(constraint: firstBaseline)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.firstBaseline.GWGetAttributeValue(.greaterThanOrEqual).rawValue:firstBaseline])
                }
                break
            case .bottom:
                if let lastBaseline = self.GWGetCuttentLayoutConstraint(.lastBaseline) {
                    GWRemoveCache(constraint: lastBaseline)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.lastBaseline.rawValue:lastBaseline])
                }
                if let lastBaseline = self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.lastBaseline.GWGetAttributeValue(.lessThanOrEqual)) {
                    GWRemoveCache(constraint: lastBaseline)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.lastBaseline.GWGetAttributeValue(.lessThanOrEqual).rawValue:lastBaseline])
                }
                if let lastBaseline = self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.lastBaseline.GWGetAttributeValue(.greaterThanOrEqual)) {
                    GWRemoveCache(constraint: lastBaseline)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.lastBaseline.GWGetAttributeValue(.greaterThanOrEqual).rawValue:lastBaseline])
                }
                break
            case .lastBaseline:
                if let bottom = self.GWGetCuttentLayoutConstraint(.bottom) {
                    GWRemoveCache(constraint: bottom)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.bottom.rawValue:bottom])
                }
                if let bottom = self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.bottom.GWGetAttributeValue(.lessThanOrEqual)) {
                    GWRemoveCache(constraint: bottom)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.bottom.GWGetAttributeValue(.lessThanOrEqual).rawValue:bottom])
                }
                if let bottom = self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.bottom.GWGetAttributeValue(.greaterThanOrEqual)) {
                    GWRemoveCache(constraint: bottom)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.bottom.GWGetAttributeValue(.greaterThanOrEqual).rawValue:bottom])
                }
                break
            case .firstBaseline:
                if let top = self.GWGetCuttentLayoutConstraint(.top) {
                    GWRemoveCache(constraint: top)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.top.rawValue:top])
                }
                if let top = self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.top.GWGetAttributeValue(.lessThanOrEqual)) {
                    GWRemoveCache(constraint: top)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.top.GWGetAttributeValue(.lessThanOrEqual).rawValue:top])
                }
                if let top = self.GWGetCuttentLayoutConstraint(GWLayoutAttribute.top.GWGetAttributeValue(.greaterThanOrEqual)) {
                    GWRemoveCache(constraint: top)
                    self.GWRemoveLayoutConstraint(constraints: [GWLayoutAttribute.top.GWGetAttributeValue(.greaterThanOrEqual).rawValue:top])
                }
                break
            default:
                break
        }
        
        if item == nil {
            print("约束视图不能为nil")
            return self
        }
        
        if firstAttribute != .notAnAttribute, let layoutConstraint = self.GWGetCuttentLayoutConstraint(firstAttribute.GWGetAttributeValue(related)) {
            if GWCheckSameAttribute(layoutConstraint, item, attribute: firstAttribute, toAttribute: twoAttribute, constant: constant, related: related, toItem: toItem, multiplier: multiplier) {
                return self
            }
            GWRemoveCache(constraint: layoutConstraint)
            self.GWRemoveLayoutConstraint(constraints: [firstAttribute.GWGetAttributeValue(related).rawValue:layoutConstraint])
        }
//        else if twoAttribute != .notAnAttribute,isGWLayoutGuide(view: toItem), let twoItem = GWGetView(toItem),let layoutConstraint = twoItem.GWGetCuttentLayoutConstraint(twoAttribute.GWGetAttributeValue(related)){
//            if GWCheckSameAttribute(layoutConstraint, toItem, attribute: twoAttribute, toAttribute: firstAttribute, constant: constant, related: related, toItem: item, multiplier: multiplier) {
//                return self
//            }
//            GWRemoveCache(constraint: layoutConstraint)
//            self.GWRemoveLayoutConstraint(constraints: [twoAttribute.GWGetAttributeValue(related).rawValue:layoutConstraint])
//        }
        
        if let superView = GWMainSuperView(view1: toItem, view2: item),let layout = GWLayoutAttribute(rawValue: attribute.rawValue) {
            let constraint = NSLayoutConstraint(item: item!,
                                                attribute: attribute,
                                                relatedBy: related,
                                                toItem: toItem,
                                                attribute: twoAttribute,
                                                multiplier: multiplier,
                                                constant: constant)
            GWAddLayoutConstraint(constraints: [layout.GWGetAttributeValue(related).rawValue:constraint])
            superView.addConstraint(constraint)
            self.currentConstraint = constraint
        }
        return self
    }

    @discardableResult
    fileprivate func GWRemoveCache(constraint: NSLayoutConstraint?) -> Self {
        GWMainViewConstraint(constraint)?.removeConstraint(constraint!)
        return self
    }

    /// 获取约束对象视图
    ///
    /// - Parameter constraint: 约束对象
    /// - Returns: 返回约束对象视图
    fileprivate func GWMainViewConstraint(_ constraint: NSLayoutConstraint!) -> GWView? {
        var view: GWView?
        if constraint != nil {
            if constraint.secondAttribute == .notAnAttribute ||
                constraint.secondItem == nil {
                view = self.GWGetOwningview(constraint.firstItem)
            }else if constraint.firstAttribute == .notAnAttribute ||
                constraint.firstItem == nil {
                view = self.GWGetOwningview(constraint.secondItem)
            }else {
                let firstItem = constraint.firstItem
                let secondItem = constraint.secondItem
                if let sameSuperView = GWMainSuperView(view1: secondItem, view2: firstItem) {
                    view = sameSuperView
                }else if let sameSuperView = GWMainSuperView(view1: firstItem, view2: secondItem) {
                    view = sameSuperView
                }else {
                    view = secondItem as? GWView
                }
            }
        }
        return view
    }

    fileprivate func isGWLayoutGuide(view:AnyObject?) -> Bool{
        if #available(iOS 9.0, *) {
            return !(view != nil && view is GWLayoutGuide)
        }
        return true
    }

    fileprivate func GWMainSuperView(view1:AnyObject?,view2:AnyObject?) -> GWView? {
        let isView1 = isGWLayoutGuide(view: view1)
        let isView2 = isGWLayoutGuide(view: view2)
        if isView1 && isView2 {
            if view1 == nil && view2 != nil {
                return GWGetView(view2)
            }
            if view1 != nil && view2 == nil {
                return GWGetView(view1)
            }
            if view1 == nil && view2 == nil {
                return nil
            }
            if GWGetSuperview(view1) != nil && GWGetSuperview(view2) == nil {
                return GWGetView(view2)
            }
            if GWGetSuperview(view1) == nil && GWGetSuperview(view2) != nil {
                return GWGetView(view1)
            }
            var data = GWSameSuperView(view1: view1, view2: view2)
            if let d1 = data.0 {
                return d1
            }else if data.1 && data.0 == nil {
                return GWGetView(view1)
            }
            data = GWSameSuperView(view1: view2, view2: view1)
            if let d1 = data.0 {
                return d1
            }else if data.1 && data.0 == nil {
                return GWGetView(view2)
            }
        }else if #available(iOS 9.0, *) {
            if isView1 && !isView2 {
                if view1 != nil {
                    let s_view = GWGetView(view1)
                    let s_guide = GWGetLayoutGuide(view2)
                    if s_view === s_guide?.owningView {
                        return s_view
                    }else {
                        if s_view?.superview === s_guide?.owningView {
                            return s_view?.superview
                        }
                        return GWMainSuperView(view1: s_view?.superview, view2: s_guide?.owningView)
                    }
                }
                return GWGetOwningview(view2);
            }else if !isView1 && isView2 {
                if view2 != nil {
                    let s_view = GWGetView(view2)
                    let s_guide = GWGetLayoutGuide(view1)
                    if s_view === s_guide?.owningView {
                        return s_view
                    }else {
                        if s_view?.superview === s_guide?.owningView {
                            return s_view?.superview
                        }
                        return GWMainSuperView(view1: s_view?.superview, view2: s_guide?.owningView)
                    }
                }
                return GWGetOwningview(view1)
            }else {
                if GWGetOwningview(view1) === GWGetOwningview(view2) {
                    return GWGetOwningview(view1)
                }
                return GWMainSuperView(view1: GWGetOwningview(view1), view2: GWGetOwningview(view2))
            }
        }
        return nil
    }

    fileprivate func GWSameSuperView(view1:AnyObject?,view2:AnyObject?) -> (GWView?,Bool){
        let isView1 = isGWLayoutGuide(view: view1)
        let isView2 = isGWLayoutGuide(view: view2)

        if isView1 && isView2 {
            var tempToItem = GWGetView(view1)
            var tempItem = GWGetView(view2)
            if let v1 = tempToItem, let v2 = tempItem {
                if GWCheckSubSuperView(supV: v1, subV: v2) != nil {
                    return (v1, false)
                }
            }
            while let toItemSuperview = tempToItem?.superview,
                let itemSuperview = tempItem?.superview  {
                    if toItemSuperview === itemSuperview {
                        return (toItemSuperview, true)
                    }else {
                        tempToItem = toItemSuperview
                        tempItem = itemSuperview
                        if tempToItem?.superview == nil && tempItem?.superview != nil {
                            if GWCheckSameSuperview(tempToItem!, tempItem!) {
                                return (tempToItem, true)
                            }
                        }else if tempToItem?.superview != nil && tempItem?.superview == nil {
                            if GWCheckSameSuperview(tempItem!, tempToItem!) {
                                return (tempItem, true)
                            }
                        }
                    }
            }
            if let v1 = GWGetView(view1), let v2 = GWGetView(view2) {
                if GWCheckSubSuperView(supV: v2, subV: v1) != nil {
                    return (v2, false)
                }
            }
        }
        return (nil, false)
    }

    fileprivate func GWCheckSubSuperView(supV:GWView?,subV:GWView?)->GWView?{
        var superView: GWView?
        if let spv = supV, let sbv = subV, let sbvspv = sbv.superview, spv !== sbv {
            func scanSubv(_ subvs: [GWView]?) -> GWView? {
                var superView: GWView?
                if let tmpsubvs = subvs, !tmpsubvs.isEmpty {
                    if tmpsubvs.contains(sbvspv) {
                        superView = sbvspv
                    }
                    if superView == nil {
                        var sumSubv = [GWView]()
                        tmpsubvs.forEach({ (sv) in
                            sumSubv.append(contentsOf: sv.subviews)
                        })
                        superView = scanSubv(sumSubv)
                    }
                }
                return superView
            }
            if scanSubv([spv]) != nil {
                superView = spv
            }
        }
        return superView
    }

    fileprivate func GWCheckSameSuperview(_ view1:GWView?,_ view2:GWView?) -> Bool {
        var tmpSingleView: GWView? = view2
        while let tempSingleSuperview = tmpSingleView?.superview {
            if view1 === tempSingleSuperview {
                return true
            }else {
                tmpSingleView = tempSingleSuperview
            }
        }
        return false
    }



    fileprivate func GWGetOwningview(_ object: AnyObject? = nil) -> GWView? {
        if let v = object as? GWView {
            return v
        }
        if #available(iOS 9.0, *),let v = object as? GWLayoutGuide {
            return v.owningView
        }
        
        if let v = self as? GWView {
            return v
        }
        if #available(iOS 9.0, *),let v = self as? GWLayoutGuide {
            return v.owningView
        }
        
        return nil
    }

    fileprivate func GWGetSuperview(_ object: AnyObject? = nil) -> GWView? {
        if let v = object as? GWView {
            return v.superview
        }
        
        if #available(iOS 9.0, *),let v = object as? GWLayoutGuide {
            return v.owningView
        }
        
        if let v = self as? GWView {
            return v.superview
        }
        
        if #available(iOS 9.0, *), let v = self as? GWLayoutGuide {
            return v.owningView
        }
        
        return GWGetView(object)?.superview
    }

    fileprivate func GWGetView(_ view:AnyObject? = nil) -> GWView? {
        guard let v = view as? GWView else { return self as? GWView }
        return v
    }

    @available(iOS 9.0, *)
    fileprivate func GWGetLayoutGuide(_ object: AnyObject? = nil) -> GWLayoutGuide? {
        if let g = object as? GWLayoutGuide {
            return g
        }
        return self as? GWLayoutGuide
    }

    fileprivate func GWGetCuttentLayoutConstraint(_ name: GWLayoutAttribute) -> NSLayoutConstraint?{
        let constraintsSet = self.GWConstraintsSet
        for (_,value) in constraintsSet.enumerated() {
            if let cons = value as? [Int:NSLayoutConstraint] , cons.keys.first == name.rawValue{
                return cons.values.first
            }
        }
        return nil
    }

    fileprivate func GWAddLayoutConstraint(constraints: [Int:NSLayoutConstraint]) {
        self.GWConstraintsSet.add(constraints)
    }

    fileprivate func GWRemoveLayoutConstraint(constraints: [Int:NSLayoutConstraint]) {
        self.GWConstraintsSet.remove(constraints)
    }

    fileprivate var GWConstraintsSet: NSMutableSet {
        let constraintsSet: NSMutableSet
        
        if let existing = objc_getAssociatedObject(self, &GWConstraintsKey) as? NSMutableSet {
            constraintsSet = existing
        } else {
            constraintsSet = NSMutableSet()
            objc_setAssociatedObject(self, &GWConstraintsKey, constraintsSet, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return constraintsSet
    }

    /// 当前添加的约束对象
    private var currentConstraint: NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &GWCurrentLayout, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let value = objc_getAssociatedObject(self, &GWCurrentLayout)
            if value != nil {
                return value as? NSLayoutConstraint
            }
            return nil
        }
    }
}

//MARK: UIFont
extension UIFont{
    func GWFontBaseTopY() -> CGFloat {
        return self.ascender - self.capHeight
    }
}
