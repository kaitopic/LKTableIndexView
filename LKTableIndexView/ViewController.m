//
//  ViewController.m
//  LKTableIndexView
//
//  Created by Aigo on 15/12/7.
//  Copyright © 2015年 Liukai. All rights reserved.
//

#import "ViewController.h"
#import "LKTableIndexView.h"

#define TEST_TEXT @"ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n1234567890"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *indexArr;
    NSMutableArray *fontArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    indexArr = [NSMutableArray array];
    fontArr = [NSMutableArray array];
    NSArray *fontArray = [UIFont familyNames];

    for (int i=0; i<26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", i + 65];
        [indexArr addObject:str];
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (NSString *fontName in fontArray) {
            if ([fontName hasPrefix:str]) {
                [mutableArr addObject:fontName];
            }
        }
        [fontArr addObject:mutableArr];
        if ([mutableArr count]==0) {
            [fontArr removeObject:mutableArr];
            [indexArr removeObject:str];
        }
    }

    LKTableIndexView *indexView = [[LKTableIndexView alloc] initWithFrame:CGRectMake(self.view.width-15, 0, 13, 0) indexArray:indexArr forTableView:_tableView];
    indexView.useCurrentIndexView = YES;
    indexView.highlightColor = [UIColor colorWithWhite:.5 alpha:.7];
    indexView.currentBackgoundColor = [UIColor colorWithRed:233/255.0 green:0 blue:0 alpha:.5];
    indexView.currentTextColor = [UIColor whiteColor];

    [self.view addSubview:indexView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return indexArr[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [fontArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fontArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:TEST_TEXT];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [TEST_TEXT length])];
    cell.textLabel.attributedText = attributedString;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:fontArr[indexPath.section][indexPath.row] size:15.f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.navigationItem.title = fontArr[indexPath.section][indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return [self sizeWithText:TEST_TEXT width:self.view.width font:[UIFont fontWithName:fontArr[indexPath.section][indexPath.row] size:15.f] lineSapce:5].height;
}

- (CGSize)sizeWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font lineSapce:(CGFloat)lineSpace {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return contentSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
