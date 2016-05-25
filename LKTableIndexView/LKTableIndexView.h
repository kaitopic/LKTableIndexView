//
//  LKTableIndexView.h
//  LKTableIndexView
//
//  Created by Aigo on 15/12/7.
//  Copyright © 2015年 Liukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (CGPoint)origin;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)right;
- (CGFloat)bottom;

- (CGSize)size;
- (CGFloat)height;
- (CGFloat)width;

- (void)setSize:(CGSize)size;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

- (void)setOrigin:(CGPoint)origin;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

@end

@interface LKTableIndexView : UILabel

/** 
 设置所属的tableView
 */
@property (nonatomic, strong) UITableView *forTableView;

/**
 索引数组
 */
@property (nonatomic, readonly) NSArray *indexArray;

/** 
 常态颜色
 */
@property (nonatomic, copy) UIColor *normolColor;

/**
 高亮颜色
 */
@property (nonatomic, copy) UIColor *highlightColor;

/**
 是否使用索引提示view,默认YES
 */
@property (nonatomic, assign) BOOL useCurrentIndexView;

/**
 索引提示view的背景色
 */
@property (nonatomic, copy) UIColor *currentBackgoundColor;

/** 
 索引提示view的文字色
 */
@property (nonatomic, copy) UIColor *currentTextColor;

/**
 索引提示view的字体
 */
@property (nonatomic, copy) UIFont *currentViewFont;

- (instancetype)initWithFrame:(CGRect)frame indexArray:(NSArray *)indexArray forTableView:(UITableView *)tableView;

@end
