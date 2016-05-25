//
//  LKTableIndexView.m
//  LKTableIndexView
//
//  Created by Aigo on 15/12/7.
//  Copyright © 2015年 Liukai. All rights reserved.
//

#import "LKTableIndexView.h"

@implementation UIView (Frame)

#pragma mark - Get Property
- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)x {
    return self.origin.x;
}

- (CGFloat)y {
    return self.origin.y;
}

- (CGFloat)right {
    return self.x + self.width;
}

- (CGFloat)bottom {
    return self.y + self.height;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)height {
    return self.size.height;
}

- (CGFloat)width {
    return self.size.width;
}


#pragma mark - Set Origin
- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect){origin, self.size};
}

- (void)setX:(CGFloat)x {
    [self setOrigin:CGPointMake(x, self.y)];
}

- (void)setY:(CGFloat)y {
    [self setOrigin:CGPointMake(self.x, y)];
}

#pragma mark - Set Size
- (void)setSize:(CGSize)size {
    self.frame = (CGRect){self.origin, size};
}

- (void)setWidth:(CGFloat)width {
    [self setSize:CGSizeMake(width, self.height)];
}

- (void)setHeight:(CGFloat)height {
    [self setSize:CGSizeMake(self.width, height)];
}

@end

@interface LKTableIndexView () {
    UIView *superView;
    UITableView *_tableView;
    UILabel *_currentIndexView;
}
@end

@implementation LKTableIndexView

- (instancetype)initWithFrame:(CGRect)frame indexArray:(NSArray *)indexArray forTableView:(UITableView *)tableView {
    
    self = [super initWithFrame:frame];
    if (self) {

        _indexArray = indexArray;
        _tableView = tableView;
        superView = tableView.superview;
        self.numberOfLines = 0;
        self.font = [UIFont systemFontOfSize:12.f];
        self.backgroundColor = _normolColor = [UIColor colorWithWhite:.5f alpha:0.5f];
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.5f;
        NSString *tempStr;
        for (int i=0; i<[indexArray count]; i++) {
            tempStr = i==0 ? indexArray[0] : [NSString stringWithFormat:@"%@\n%@", tempStr, indexArray[i]];
        }
        self.text = tempStr;
        self.height = [self sizeWithText:tempStr width:frame.size.width fontSize:12 lineSapce:0].height+10;
        /*
         y和height由自动计算得出
         */
        self.frame = CGRectMake(frame.origin.x, (superView.height-self.height)/2, frame.size.width, self.height);
    }
    return self;
}

- (void)setNormolColor:(UIColor *)normolColor {
    _normolColor = normolColor;
    self.backgroundColor = _normolColor;
}

- (void)setUseCurrentIndexView:(BOOL)useCurrentIndexView {
    
    _useCurrentIndexView = useCurrentIndexView;
    if (useCurrentIndexView) {
        _currentIndexView = [self setCurrentIndexView];
        [superView addSubview:_currentIndexView];
    }
}

- (UILabel *)setCurrentIndexView {
  
    UILabel *currentIndexView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    currentIndexView.center = superView.center;
    currentIndexView.textAlignment = NSTextAlignmentCenter;
    currentIndexView.font = _currentViewFont ? _currentViewFont :[UIFont boldSystemFontOfSize:30.f];
    currentIndexView.backgroundColor = _currentBackgoundColor ? _currentBackgoundColor : [UIColor colorWithWhite:.4f alpha:.5f];
    currentIndexView.alpha = 0.f;
    currentIndexView.layer.masksToBounds = YES;
    currentIndexView.layer.cornerRadius = currentIndexView.width/2;
    
    return currentIndexView;
}

- (void)setCurrentBackgoundColor:(UIColor *)currentBackgoundColor {
    _currentBackgoundColor = currentBackgoundColor;
    _currentIndexView.backgroundColor = currentBackgoundColor;
}

- (void)setCurrentTextColor:(UIColor *)currentTextColor {
    _currentTextColor = currentTextColor;
    _currentIndexView.textColor = currentTextColor;
}

- (void)setCurrentViewFont:(UIFont *)currentViewFont {
    _currentViewFont = currentViewFont;
    _currentIndexView.font = currentViewFont;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchAction:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchAction:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [UIView animateWithDuration:.7f animations:^{
        _currentIndexView.alpha = 0.f;
        self.backgroundColor = _normolColor ? _normolColor : [UIColor colorWithWhite:.5f alpha:.5f];
    }];
}

- (void)touchAction:(NSSet *)touches {
    
    self.backgroundColor = _highlightColor ? _highlightColor : _normolColor;
    [UIView animateWithDuration:.3f animations:^{
        _currentIndexView.alpha = 1.f;
    }];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    int index = (int)((point.y/self.height)*[_indexArray count]);
    if (index>[_indexArray count]-1 || index<0) return;

    _currentIndexView.text = _indexArray[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [_tableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (CGSize)sizeWithText:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize lineSapce:(CGFloat)lineSpace {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle};
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return contentSize;
}

@end




