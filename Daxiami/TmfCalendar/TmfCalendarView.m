//
//  TmfCalendarView.m
//  Daxiami
//
//  Created by 大虾咪 on 2017/7/4.
//  Copyright © 2017年 大虾咪. All rights reserved.
//

#import "TmfCalendarView.h"
#import "TmfCalendarViewCell.h"
#import "TmfCalendarModel.h"

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@interface TmfCalendarView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>


@property(nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dayArr;//阳历
@property(nonatomic, strong) NSMutableArray *chineseArr;//农历

@property(nonatomic, strong) TmfCalendarModel *calendarModel;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIButton *nextBtn;
@property(nonatomic, strong) UIButton *lastBtn;
//@property(nonatomic, strong) UILabel *<#name#>
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *footLabel;
@property(nonatomic, copy) NSString *rowIndex;
@property(nonatomic, strong) NSArray *weekArr;


@end

@implementation TmfCalendarView
{
    NSInteger currentIndex;
    NSInteger lastMonthIndex;
    NSInteger nextMonthIndex;
}

- (NSMutableArray *)dayArr{
    if (!_dayArr) {
        _dayArr = [[NSMutableArray alloc] init];
    }
    return _dayArr;
}

- (NSMutableArray *)chineseArr{
    if (!_chineseArr) {
        _chineseArr = [[NSMutableArray alloc] init];
    }
    return _chineseArr;
}

- (void)initCollectionView{
    

    
    _calendarModel = [[TmfCalendarModel alloc] init];
    __weak __typeof(self)weakSelf = self;
    _calendarModel.dateBlock = ^(NSInteger year, NSInteger month) {
        weakSelf.titleLb.text = [NSString stringWithFormat:@"%ld年%ld月",year,month];
    };

    self.dayArr = _calendarModel.getDayArray;
    NSArray *arr = [NSArray arrayWithArray:self.dayArr];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

    [self.chineseArr addObject:[self getChineseCalendarWithDate:obj]];
        
    }];
    
    
    currentIndex = _calendarModel.currentIndex;
    lastMonthIndex = _calendarModel.lastMonthIndex;
    nextMonthIndex = _calendarModel.nextMonthIndex;
    
    _customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    _customLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_customLayout];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
    
    // 注册cell、sectionHeader、sectionFooter
    [_collectionView registerClass:[TmfCalendarViewCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
}

#pragma mark - =========UICollectionViewDelegateFlowLayout =========

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth)/7.0, (kScreenWidth)/7.0+20);
    
}
//每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

//每行内部cell item的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){kScreenWidth,100};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){kScreenWidth,300};
}

#pragma mark - =========UICollectionViewDataSource =========
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    NSLog(@"self.dayarr:%s %@",__func__,self.dayArr);
    
    return self.dayArr.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TmfCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"cellcellcell");
        //        never action
    }
    #pragma mark - =========给cell添加边框 =========
//   TODO:方法三  kUIColorFromRGB(0xeeeeee).CGColor 这个颜色可以省去上边CALayer
    cell.layer.borderColor = kUIColorFromRGB(0xeeeeee).CGColor;
    cell.layer.borderWidth = 0.5;
    cell.layer.masksToBounds = YES;
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.calendarLabel.text = [self.dayArr[indexPath.row] substringFromIndex:6];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    
        NSDate *nowDateSystem = [NSDate date];
        NSDateFormatter *dateFm = [[NSDateFormatter alloc] init];
        [dateFm setDateFormat:@"yyyyMM"];
        NSString *nowDateStrSystem = [dateFm stringFromDate:nowDateSystem];

        //显示当天
        if (currentIndex==indexPath.row &&[nowDateStrSystem isEqualToString:[self.dayArr[indexPath.row] substringToIndex:6]] ) {
            cell.calendarLabel.textColor = [UIColor whiteColor];
            cell.calendarLabel.layer.cornerRadius = cell.calendarLabel.frame.size.height/2.0;
            cell.calendarLabel.clipsToBounds = YES;
            cell.calendarLabel.backgroundColor = [UIColor redColor];
        }else{
            
            
            if (indexPath.row<=lastMonthIndex||indexPath.row>=(self.dayArr.count-nextMonthIndex)) {
                
                cell.calendarLabel.textColor = [UIColor grayColor];
                cell.calendarLabel.clipsToBounds = NO;
                cell.calendarLabel.backgroundColor = [UIColor clearColor];
                
            }else{
                cell.calendarLabel.textColor = [UIColor blackColor];
                cell.calendarLabel.clipsToBounds = NO;
                cell.calendarLabel.backgroundColor = [UIColor clearColor];
            }
        }

        
    
    cell.contextLabel.text = self.chineseArr[indexPath.row];
//    NSString *contextString = [[NSUserDefaults standardUserDefaults] objectForKey:self.dayArr[indexPath.row]];
//        if(contextString.length>0 ){
//            cell.contextLabel.text = contextString;
//        }else{
//            cell.contextLabel.text = @"";
//        }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor colorWithRed:0.98f green:0.92f blue:0.80f alpha:1.0f];
        #pragma mark - =========上个月  下个月 =========
        CGFloat width = self.bounds.size.width/7.0;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            for (int i = 0; i<self.weekArr.count; i++) {
                
                UILabel *_weekLabel = [[UILabel alloc] init];
                _weekLabel.textAlignment = NSTextAlignmentCenter;

                _weekLabel.frame = CGRectMake(0+width*i, 60,width, 30);
                _weekLabel.text = self.weekArr[i];
                [headerView addSubview:_weekLabel];
                
            }

        });
        
        [headerView addSubview:self.lastBtn];
        
        [headerView addSubview:self.nextBtn];
        //年月显示
        [headerView addSubview:self.titleLb];
        

        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor colorWithRed:0.98f green:0.92f blue:0.80f alpha:1.0f];

       
        [footerView addSubview:self.footLabel];
        footerView.backgroundColor = [UIColor whiteColor];
        
        return footerView;
    }
    
    return nil;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0){
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0);{
    
}

#pragma mark - ========= UICollectionViewDelegate=========
// 设置是否允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}
// 选中操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    
    
     self.rowIndex = self.dayArr[indexPath.row];
  
    NSLog(@"rowIndex:%@",self.rowIndex);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.textField];

//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.layer.cornerRadius = cell.bounds.size.width/2.0;
//    cell.layer.masksToBounds = YES;
//    cell.backgroundColor = [UIColor redColor];
    
}

// 取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
}
//这个不是必须的方法 是Cell 将要显示
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);//缩放比例
    [UIView animateWithDuration:0.8 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);//还原为1
    }];
}


- (void)nextMonthAction {
    
    [self.dayArr removeAllObjects];
    [self.chineseArr removeAllObjects];

    self.dayArr = [self.calendarModel getNextDayArray];

    [self.dayArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.chineseArr addObject:[self getChineseCalendarWithDate:obj]];
        
    }];
    
    

    lastMonthIndex = _calendarModel.lastMonthIndex;
    nextMonthIndex = _calendarModel.nextMonthIndex;
    [self.collectionView reloadData];

}
- (void)lastMonthAction {
    [self.dayArr removeAllObjects];
    [self.chineseArr removeAllObjects];
    self.dayArr = [self.calendarModel getLastDayArray];
        NSLog(@"self.dayArr:%@",self.dayArr);

    [self.dayArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"objobjobjobj:%@",obj);

        [self.chineseArr addObject:[self getChineseCalendarWithDate:obj]];
        
    }];
    
    
    lastMonthIndex = _calendarModel.lastMonthIndex;
    nextMonthIndex = _calendarModel.nextMonthIndex;
    [self.collectionView reloadData];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:self.rowIndex];
    [_collectionView reloadData];
    [textField resignFirstResponder];
    
    [textField removeFromSuperview];

    return YES;
}

#pragma mark - =========懒加载控件 =========
- (UILabel *)footLabel{
    if (!_footLabel) {
        _footLabel = [[UILabel alloc] init];
        _footLabel.frame = CGRectMake(10, 10, kScreenWidth-20, 100);
        _footLabel.numberOfLines = 0;
        _footLabel.text = @"快乐生活每一天！";
        _footLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footLabel;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 20, 60, 30)];
        [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextMonthAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextBtn;
}
- (UIButton *)lastBtn{
    if (!_lastBtn) {
        _lastBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 30)];
        [_lastBtn setTitle:@"上一月" forState:UIControlStateNormal];
        [_lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_lastBtn addTarget:self action:@selector(lastMonthAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastBtn;
}

//-

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, kScreenWidth-100, 30)];
        //        _titleLb.backgroundColor = [UIColor redColor];
        
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

//弹出UITextFiled
- (UITextField *)textField{
    if (!_textField) {
        _textField= [[UITextField alloc] init];
        _textField.frame = CGRectMake(10, 80, 200, 60);
        _textField.center = self.center;
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;//变为搜索按钮
        _textField.backgroundColor = [UIColor orangeColor];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:@"输入备忘内容（最多五个汉字）"];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedStr.length)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedStr.length)];
        _textField.attributedPlaceholder = attributedStr;
        [_textField becomeFirstResponder];
    }
    return _textField;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initCollectionView];
        
        _weekArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        
        
    }
    return self;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    
}
// 该判断用于联想输入    10个字符  5个汉字
- (void)textFieldDidChange:(UITextField *)tf
{
    [self limitCharater:tf limit:10];
}

//限制联想输入的字数
- (void)limitCharater:(UITextField *)tf limit:(int )count{
    
    if ([self characterCount:tf] > count) {
        while ([self characterCountWithString:tf.text] > count && tf.markedTextRange== nil) {
            
            tf.text = [tf.text substringToIndex:tf.text.length - 1];
        
            [[NSUserDefaults standardUserDefaults] setObject:tf.text forKey:self.rowIndex];
            [_collectionView reloadData];
            [tf resignFirstResponder];
            
            [tf removeFromSuperview];
            
        }
    }
}

#pragma mark - 计算农历 期
-(NSString*)getChineseCalendarWithDate:(NSString*)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    //    [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *dateTemp = nil;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    
    [dateFormater setDateFormat:@"yyyyMMdd"];
    
    dateTemp = [dateFormater dateFromString:date];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:dateTemp];
    
//    NSLog(@"year:%d_month:%d_day:%d  date%@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    if ([d_str isEqualToString:@"初一"]) {
        d_str = m_str;
    }
    NSString *chineseCal_str =d_str;//[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    return chineseCal_str;
}

/**
 *  计算字符个数(一个汉字等于两个字符)
 */
- (NSInteger)characterCount:(UITextField *)tf
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [tf.text dataUsingEncoding:enc];
    return data.length;
}
/**
 *  计算字符个数(一个汉字等于两个字符)
 */
- (NSInteger)characterCountWithString:(NSString *)string
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:enc];
    return data.length;
    
}
@end
