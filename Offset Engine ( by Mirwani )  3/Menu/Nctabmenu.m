//
//  Nctabmenu.m
//  ENGINE
//
//  Created by DH on 2023/2/3.
//  Shared By @MirWani ..............
//
#import <UIKit/UIKit.h>
#import "Nctabmenu.h"
#import <objc/runtime.h>
//死全家的GG爆 狗逼一个 操他妈的血逼
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface Nctabmenu ()<UITableViewDataSource,UITableViewDelegate>
//死全家的GG爆 狗逼一个 操他妈的血逼
@end
//死全家的GG爆 狗逼一个 操他妈的血逼
bool 菜单控制; //用来控制菜单当前是否打开状态,防止点击悬浮窗重复打开首页菜单

static UITextField*textField;

static UIView *NcMenuView;
static UITableView *NcTableView;
static UIButton *btn;
static UILabel *MyLabel;
static UIWindow *window;
static UIView *调试;
static UIView *拖动角标;
static UIButton *群;
static UIButton *源码;
static UIButton *按钮;
static UISwitch *开关;


static UISlider * 雷达显示大小;
static UISlider * 雷达X轴;
static UISlider * 雷达Y轴;
static UISlider * 预警显示大小;
static UISlider * 视野显示大小;
static UISlider * 打击范围大小;
static UISlider * 打击距离大小;
static UISlider * 命中率大小;
static UISlider * 物资显示距离;
static UISegmentedControl *segment;
static float 比例 = 1;

bool 射线开关 = NO;
bool 名字开关 = NO;
bool 血量开关 = NO;
bool 骨骼开关 = NO;
bool 持枪开关 = NO;
bool 雷达开关 = NO;
bool 被瞄开关 = NO;
bool 背敌模式 = NO;
bool 自瞄开关 = NO;
bool 追踪开关 = NO;
bool 静默开关 = NO;
bool 倒地开关 = NO;
bool 枪械开关 = NO;
bool 药品开关 = NO;
bool 载具开关 = NO;
bool 配件开关 = NO;
bool 美化开关 = NO;
bool 无后开关 = NO;
bool 防抖开关 = NO;
bool 瞬击开关 = NO;
bool 聚点开关 = NO;

@implementation Nctabmenu


static UILabel *MyLabel1;
static UILabel *MyLabel2;
static UILabel *MyLabel3;
static UILabel *MyLabel4;
static UILabel *MyLabel5;
static UILabel *MyLabel6;
static UILabel *MyLabel7;
static UILabel *MyLabel8;
static UILabel *MyLabel9;




+ (void)onConsoleButtonTapped{
        [Nctabmenu NcMenuFun];
}


+ (void)NcMenuFun{
    if(!菜单控制){
        菜单控制 = YES; // 标志菜单已经打开，防止重复打开
        CGFloat Width = 350; CGFloat Height = 280; // 设置菜单的宽度和高度
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow; // 获取应用程序的主窗口
        NcMenuView = [[UIView alloc]initWithFrame:CGRectMake(0,0, Width, mainWindow.frame.size.height-50)]; // 创建菜单的UIView并设置它的大小
//        NcMenuView.backgroundColor=[UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:245 / 255.0 alpha:0]; // 设置背景颜色
//        NcMenuView.layer.borderColor = [[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0] CGColor]; // 设置边框颜色
        
        NcMenuView.backgroundColor=[UIColor whiteColor]; // 设置背景颜色
        NcMenuView.layer.borderColor = [[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0] CGColor]; // 设置边框颜色
        NcMenuView.layer.borderWidth = 1.0f; // 设置边框宽度
        NcMenuView.layer.cornerRadius = 20; // 设置圆角半径
        NcMenuView.hidden=NO; // 显示菜单
        NcMenuView.center = mainWindow.center; // 设置菜单中心点位置
        NcMenuView.alpha = 0.0f; // 初始化菜单的透明度为0
        [mainWindow addSubview:NcMenuView]; // 添加菜单到主窗口中
        // 添加拖动图标
//        UIPanGestureRecognizer *pan1=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movingBtn:)];
//        [mainWindow addGestureRecognizer:pan1];
        [UIView animateWithDuration:1 animations:^{
            NcMenuView.alpha = 1; // 动画显示菜单，从透明到不透明
        }];
        
        UIView *h = [[UIView alloc]initWithFrame:CGRectMake(0,0, NcMenuView.frame.size.width, 50)]; // 创建HeaderView并设置它的大小
        h.backgroundColor=[UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:245 / 255.0 alpha:0]; // 设置背景颜色
        h.layer.cornerRadius = 20; // 设置圆角半径
        h.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影颜色
        h.layer.shadowOffset = CGSizeMake(0,-3); // 设置阴影偏移，默认(0, -3)
        h.layer.shadowOpacity = 0; // 设置阴影透明度，默认0
        h.layer.shadowRadius = 20; // 设置阴影半径，默认3
        [NcMenuView addSubview:h]; // 将HeaderView添加到菜单中
        
        // 添加拖动图标
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movingBtn:)];
        [h addGestureRecognizer:pan];
        
        //UIButton *touxiang = [[UIButton alloc]initWithFrame:CGRectMake(10,10, 35, 35)]; // 创建头像按钮并设置它的大小
//        touxiang.backgroundColor=[UIColor clearColor]; // 设置背景颜色
//        // 异步加载头像
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            // 异步加载用户头像数据
//            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:caidan options:NSDataBase64DecodingIgnoreUnknownCharacters];
//
//            UIImage *decodedImage = [UIImage imageWithData:imageData];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 在主线程更新UI，显示用户头像
//                touxiang.layer.contents = (id)decodedImage.CGImage;
//            });
//        });
//        // 设置头像圆角效果
//        touxiang.clipsToBounds = YES;
//        //touxiang.layer.cornerRadius = CGRectGetWidth(touxiang.bounds) / 2;
//        // 给头像按钮添加点击事件
//        [touxiang addTarget:self action:@selector(调试) forControlEvents:UIControlEventTouchUpInside];
//        // 添加头像按钮到界面上
//        [h addSubview:touxiang];
        
        // 创建一个标题标签
        UILabel *BT = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, h.frame.size.width, 30)];
        BT.numberOfLines = 0;
        BT.lineBreakMode = NSLineBreakByCharWrapping;
        BT.text = @"STAR ENGINE ESP - BETA";
        BT.textAlignment = NSTextAlignmentCenter;
        BT.font = [UIFont boldSystemFontOfSize:20]; // 设置为粗体，大小为 20
        BT.textColor = [UIColor redColor];
        // 添加标题标签到界面上
        [h addSubview:BT];
        
        // 创建一个关闭按钮
        UIButton *关闭 = [[UIButton alloc] initWithFrame:CGRectMake(h.frame.size.width-35,10, 33, 33)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 异步加载关闭按钮的图片数据
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:GuanBi options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 在主线程更新UI，显示关闭按钮的图片
                关闭.layer.contents = (id)decodedImage.CGImage;
            });
        });
        // 设置关闭按钮圆角效果
        关闭.clipsToBounds = YES;
        关闭.layer.cornerRadius = CGRectGetWidth(关闭.bounds) / 2;
        // 给关闭按钮添加点击事件
        [关闭 addTarget:self action:@selector(MsHomeOFFFun) forControlEvents:UIControlEventTouchUpInside];
        // 添加关闭按钮到界面上
        [h addSubview:关闭];
        
        // 创建一个UITableView用于显示列表数据
        NcTableView = [[UITableView alloc]initWithFrame:CGRectMake(20,60,NcMenuView.frame.size.width-40,NcMenuView.frame.size.height-70) style:UITableViewStyleGrouped];
        NcTableView.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:245 / 255.0 alpha:0]; //总的背景颜色
        NcTableView.bounces = YES;
        NcTableView.dataSource = (id<UITableViewDataSource>) self;
        NcTableView.delegate = (id<UITableViewDelegate>) self;
        NcTableView.showsVerticalScrollIndicator = NO;
        NcTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        NcTableView.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        // 添加UITableView到界面上
        [NcMenuView addSubview:NcTableView];
    }
}
//关闭菜单
+ (void)MsReturnMenu{
    菜单控制 = NO;
    [UIView animateWithDuration:0.5 animations:^{
        NcMenuView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [NcMenuView removeFromSuperview];
    }];
}
//拖动
// 实现一个移动按钮的方法，使用UIPanGestureRecognizer手势识别器

+(void)movingBtn:(UIPanGestureRecognizer *)recognizer{
    // 获取手势移动的距离
    CGPoint translation = [recognizer translationInView:NcMenuView];
    // 根据手势状态进行操作
    if(recognizer.state == UIGestureRecognizerStateBegan){
        // 手势开始时，不进行任何操作
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        // 手势移动时，改变按钮的位置
        NcMenuView.center = CGPointMake(NcMenuView.center.x + translation.x, NcMenuView.center.y + translation.y);
        // 将手势移动的距离重置为0
        [recognizer setTranslation:CGPointZero inView:NcMenuView];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        // 手势结束时，将按钮的位置更新为最后一次移动的位置
        CGFloat newX2=NcMenuView.center.x;
        CGFloat newY2=NcMenuView.center.y;
        NcMenuView.center = CGPointMake(newX2, newY2);
        // 将手势移动的距离重置为0
        [recognizer setTranslation:CGPointZero inView:NcMenuView];
    }
}
+ (void)调试{
    
    if(调试.hidden == YES){
        调试.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            调试.alpha = 1;
        }];
        
    }else{
        
        调试 = [[UIView alloc]
              initWithFrame:CGRectMake(0,0, NcMenuView.frame.size.width - 35, 50)];
        调试.backgroundColor=[UIColor whiteColor];
        调试.layer.cornerRadius = 5;
        调试.alpha = 0;
        [NcMenuView addSubview:调试];
        
        [UIView animateWithDuration:0.5 animations:^{
            调试.alpha = 1;
        }];
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movingBtn:)];
        [调试 addGestureRecognizer:pan];
        
        UIButton *工具 = [[UIButton alloc]
                        initWithFrame:CGRectMake(10,10, 调试.frame.size.width / 4-10, 30)];
        [工具 setTitle:@"关闭" forState:UIControlStateNormal];
        [工具 setTitleColor:[UIColor colorWithRed:67 / 255.0 green:110 / 255.0 blue:238 / 255.0 alpha:1] forState:UIControlStateNormal];//p1颜色
        工具.backgroundColor=[UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:245 / 255.0 alpha:1];
        工具.layer.borderWidth = 1.0f;//边框大小
        [工具.titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
        工具.clipsToBounds = YES;
        工具.layer.cornerRadius = 5;
        [工具 addTarget:self action:@selector(工具:) forControlEvents:UIControlEventTouchUpInside];
        [调试 addSubview:工具];
        
        UIButton *调整 = [[UIButton alloc]
                        initWithFrame:CGRectMake(调试.frame.size.width / 4 + 10,10, 调试.frame.size.width / 4-10, 30)];
        
        [调整 setTitle:@"菜单调整" forState:UIControlStateNormal];
        [调整 setTitleColor:[UIColor colorWithRed:67 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1] forState:UIControlStateNormal];
        调整.backgroundColor=[UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:245 / 255.0 alpha:0];
        调整.layer.borderWidth = 1.0f;
        [调整.titleLabel setFont:[UIFont systemFontOfSize:15]];
        调整.clipsToBounds = YES;
        调整.layer.cornerRadius = 5;
        [调整 addTarget:self action:@selector(菜单调整) forControlEvents:UIControlEventTouchUpInside];
        [调试 addSubview:调整];
        
    }
    
}
+ (void)菜单调整{
    
    if(segment.alpha == 1){
        源码.hidden = NO;
        群.hidden = NO;
        [UIView animateKeyframesWithDuration:0.6 delay:0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
                segment.alpha = 0;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.6 animations:^{
                源码.alpha = 1;
                群.alpha = 1;
            }];
        }completion:^(BOOL finished) {
            [segment removeFromSuperview];
        }];
        
    }else{
        
        NSArray *array = [NSArray arrayWithObjects:@"还原",@"缩小",@"放大", nil];
        //初始化UISegmentedControl
        segment = [[UISegmentedControl alloc]initWithItems:array];
        //设置frame
        segment.frame = CGRectMake(调试.frame.size.width / 4*2 + 10, 10, 调试.frame.size.width / 4*2-10, 30);
        segment.apportionsSegmentWidthsByContent = YES;
        segment.momentary = YES;
        segment.alpha = 0;
        //添加到视图
        [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
        [调试 addSubview:segment];
        
        [UIView animateKeyframesWithDuration:0.6 delay:0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
                源码.alpha = 0;
                群.alpha = 0;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.6 animations:^{
                segment.alpha = 1;
            }];
        }completion:^(BOOL finished) {
            源码.hidden = YES;
            群.hidden = YES;
        }];
    }
}

+ (void)工具:(UIButton *)a{
    [UIView transitionWithView: NcTableView
                      duration: 0.5f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
        [NcTableView reloadData];
        调试.alpha = 0;
    }
                    completion: ^(BOOL isFinished)
     {
        调试.hidden = YES;
    }];
}

+ (void)change:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        比例 =  1;
        [UIView animateWithDuration:0.2 animations:^{
            NcMenuView.transform = CGAffineTransformMakeScale(比例, 比例);
        }];
    }else if (sender.selectedSegmentIndex == 1) {
        比例 =  比例 - 0.1;
        [UIView animateWithDuration:0.2 animations:^{
            NcMenuView.transform = CGAffineTransformMakeScale(比例, 比例);
        }];
    }else if (sender.selectedSegmentIndex == 2){
        比例 =  比例 + 0.1;
        [UIView animateWithDuration:0.2 animations:^{
            NcMenuView.transform = CGAffineTransformMakeScale(比例, 比例);
        }];
    }
}

#pragma mark - TbaleView的数据源代理方法实现

//总菜单
+ (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark - 第二个控制器行树
//设置分组
+ (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)return 12;
    else if(section == 1)return 15;
    else if(section == 2)return 5;
//    else if(section == 3)return 3;
    return 1;
}

// 设置顶部间距
+ (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
    
}
//设置底部间距
+ (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}
//设置分组名称
+ (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerLabel;
    
    if(section == 0) headerLabel = @"绘制专区";
    else if(section == 1) headerLabel = @"功能专区";
    else if(section == 2) headerLabel = @"物资专区";
//    else if(section == 3) headerLabel = @"美化功能";
    return headerLabel;
}

//设置底部文字
+ (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *copyright;
    
    return copyright;
}
+ (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    
    
}
//设置表格大小
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
}

#pragma mark - 第一层

+ (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0]; // 设置为粗体，大小为 16
    
    
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
    
    if(indexPath.section==0){
        if(indexPath.row==0){
            cell.textLabel.text = @"显示射线";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:shexian options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(15, 15);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 射线开关;
            switchView.tag=1;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
            
        }
        if(indexPath.row==1){
            cell.textLabel.text = @"显示血量";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:xueliang options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 血量开关;
            switchView.tag=2;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==2){
            cell.textLabel.text = @"显示名字";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:mingzi options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 名字开关;
            switchView.tag=3;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==3){
            cell.textLabel.text = @"显示骨骼";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:guge options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 骨骼开关;
            switchView.tag=4;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==4){
            cell.textLabel.text = @"显示持枪";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:chiqiang options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 持枪开关;
            switchView.tag=5;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==5){
            cell.textLabel.text = @"被瞄预警";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:leida1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 被瞄开关;
            switchView.tag=18;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==6){
            cell.textLabel.text = @"显示雷达";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:leida1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 雷达开关;
            switchView.tag=13;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==7){
            cell.textLabel.text = @"背敌预警";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:beidi options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 背敌模式;
            switchView.tag=20;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;

        }
        if(indexPath.row==8){
            cell.textLabel.text = @"敌人方框";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:beidi options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSArray *array = [NSArray arrayWithObjects:@"3D",@"四角",@"关闭", nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
            segment.frame = CGRectMake(0,5,150,30);
            segment.selectedSegmentIndex = 框架开关;
            segment.apportionsSegmentWidthsByContent = NO;
            [segment addTarget:self action:@selector(gongnchange6:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = segment;

        }
        
        if(indexPath.row==9){
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:leidadaxiao options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            雷达显示大小 = [[UISlider alloc]init];
            cell.textLabel.text = @"雷达大小";
            cell.transform = CGAffineTransformMakeScale(1, 1);
            雷达显示大小.minimumValue = 0;
            雷达显示大小.maximumValue = 500;
            雷达显示大小.hidden = NO;
            雷达显示大小.value =400;
            雷达显示大小.continuous =YES;
            [雷达显示大小 setContinuous:YES];
            // 改变滑条按钮的大小
            NSData *imageData1;
            imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
            thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
            [雷达显示大小 setThumbImage:thumbImage forState:UIControlStateNormal];
            [雷达显示大小 addTarget:self action:@selector(leida:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = 雷达显示大小;
            
            MyLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
            MyLabel1.text = [NSString stringWithFormat:@"%.2f",雷达显示大小];
            MyLabel1.numberOfLines = 0;
            MyLabel1.lineBreakMode = NSLineBreakByCharWrapping;
            MyLabel1.textAlignment = NSTextAlignmentCenter;
            MyLabel1.font = [UIFont boldSystemFontOfSize:13];
            MyLabel1.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
            [cell.contentView addSubview:MyLabel1];
        }
        if(indexPath.row==10){
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:leidadaxiao options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            雷达X轴 = [[UISlider alloc]init];
            cell.textLabel.text = @"雷达X轴";
            cell.transform = CGAffineTransformMakeScale(1, 1);
            雷达X轴.minimumValue = 0;
            雷达X轴.maximumValue = 500;
            雷达X轴.hidden = NO;
            雷达X轴.value =100;
            雷达X轴.continuous =YES;
            // 改变滑条按钮的大小
            NSData *imageData1;
            imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
            thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
            [雷达X轴 setThumbImage:thumbImage forState:UIControlStateNormal];
            [雷达X轴 addTarget:self action:@selector(雷达X轴调节:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = 雷达X轴;
            
            MyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
            MyLabel2.text = [NSString stringWithFormat:@"%.2f",雷达X轴];
            MyLabel2.numberOfLines = 0;
            MyLabel2.lineBreakMode = NSLineBreakByCharWrapping;
            MyLabel2.textAlignment = NSTextAlignmentCenter;
            MyLabel2.font = [UIFont boldSystemFontOfSize:13];
            MyLabel2.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
            [cell.contentView addSubview:MyLabel2];
        }
        if(indexPath.row==11){
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:leidadaxiao options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            雷达Y轴 = [[UISlider alloc]init];
            cell.textLabel.text = @"雷达Y轴";
            cell.transform = CGAffineTransformMakeScale(1, 1);
            雷达Y轴.minimumValue = 0;
            雷达Y轴.maximumValue = 500;
            雷达Y轴.hidden = NO;
            雷达Y轴.value =100;
            雷达Y轴.continuous =YES;
            [雷达Y轴 setContinuous:YES];
            // 改变滑条按钮的大小
            NSData *imageData1;
            imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
            thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
            [雷达Y轴 setThumbImage:thumbImage forState:UIControlStateNormal];
            [雷达Y轴 addTarget:self action:@selector(雷达Y轴调节:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = 雷达Y轴;
            
            
            MyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
            MyLabel3.text = [NSString stringWithFormat:@"%.2f",雷达Y轴];
            MyLabel3.numberOfLines = 0;
            MyLabel3.lineBreakMode = NSLineBreakByCharWrapping;
            MyLabel3.textAlignment = NSTextAlignmentCenter;
            MyLabel3.font = [UIFont boldSystemFontOfSize:13];
            MyLabel3.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
            [cell.contentView addSubview:MyLabel3];
        }
//        if(indexPath.row==12){
//            NSData *imageData;
//            imageData = [[NSData alloc] initWithBase64EncodedString:yaqiang options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            UIImage *decodedImage = [UIImage imageWithData:imageData];
//            cell.imageView.image=decodedImage;
//            CGSize itemSize = CGSizeMake(18, 18);
//            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//            [cell.imageView.image drawInRect:imageRect];
//            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//
//            预警显示大小 = [[UISlider alloc]init];
//            cell.textLabel.text = @"预警大小";
//            cell.transform = CGAffineTransformMakeScale(1, 1);
//            预警显示大小.minimumValue = 0;
//            预警显示大小.maximumValue = 50;
//            预警显示大小.hidden = NO;
//            预警显示大小.value =38;
//            预警显示大小.continuous =YES;
//            [预警显示大小 setContinuous:YES];
//            // 改变滑条按钮的大小
//            NSData *imageData1;
//            imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
//            thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
//            [预警显示大小 setThumbImage:thumbImage forState:UIControlStateNormal];
//            [预警显示大小 addTarget:self action:@selector(预警大小调节:) forControlEvents:UIControlEventValueChanged];
//            cell.accessoryView = 预警显示大小;
//
//
//            MyLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
//            MyLabel4.text = [NSString stringWithFormat:@"%.2f",预警显示大小];
//            MyLabel4.numberOfLines = 0;
//            MyLabel4.lineBreakMode = NSLineBreakByCharWrapping;
//            MyLabel4.textAlignment = NSTextAlignmentCenter;
//            MyLabel4.font = [UIFont boldSystemFontOfSize:13];
//            MyLabel4.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
//            [cell.contentView addSubview:MyLabel4];
//        }
    }
    
    if(indexPath.section==1){
        if(indexPath.row==0){
            cell.textLabel.text = @"触摸自瞄";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:zimiao options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 自瞄开关;
            switchView.tag=7;
            switchView.thumbTintColor = [UIColor whiteColor]; // 设置滑块的颜色
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        if(indexPath.row==1){
            cell.textLabel.text = @"倒地自瞄";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:zimiao options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 倒地开关;
            switchView.tag=16;
            switchView.thumbTintColor = [UIColor whiteColor]; // 设置滑块的颜色
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        if(indexPath.row==2){
            cell.textLabel.text = @"函数追踪";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:zimiao options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 追踪开关;
            switchView.tag=17;
            switchView.thumbTintColor = [UIColor whiteColor]; // 设置滑块的颜色
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        
        if(indexPath.row==3){
            cell.textLabel.text = @"自瞄速度";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:qiangdu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSArray *array = [NSArray arrayWithObjects:@"低",@"中",@"高", nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
            segment.frame = CGRectMake(0,5,150,30);
            segment.selectedSegmentIndex = 自瞄速度;
            segment.apportionsSegmentWidthsByContent = NO;
            [segment addTarget:self action:@selector(gongnchange1:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = segment;
            
        }

        if(indexPath.row==4){
            cell.textLabel.text = @"自瞄模式";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:qiangdu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSArray *array = [NSArray arrayWithObjects:@"自动",@"开镜",@"开火", nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
            segment.frame = CGRectMake(0,5,150,30);
            segment.selectedSegmentIndex = 自瞄模式;
            segment.apportionsSegmentWidthsByContent = NO;
            [segment addTarget:self action:@selector(gongnchange2:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = segment;

        }
        if(indexPath.row==5){
            cell.textLabel.text = @"锁定部位";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:yaqiang options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSArray *array = [NSArray arrayWithObjects:@"固定",@"随机", nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
            segment.frame = CGRectMake(0,5,150,30);
            segment.selectedSegmentIndex = 自瞄部位;
            segment.apportionsSegmentWidthsByContent = NO;
            [segment addTarget:self action:@selector(gongnchange5:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = segment;

        }
        if(indexPath.row==6){
            cell.textLabel.text = @"打击模式";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSArray *array = [NSArray arrayWithObjects:@"动态",@"静态", nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
            segment.frame = CGRectMake(0,5,150,30);
            segment.selectedSegmentIndex = 圆圈模式;
            segment.apportionsSegmentWidthsByContent = NO;
            [segment addTarget:self action:@selector(gongnchange4:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = segment;
            
        }
        
        if (indexPath.row == 7) {
        
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:yaqiang options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            视野显示大小 = [[UISlider alloc]init];
            cell.textLabel.text = @"压枪速率";
            cell.transform = CGAffineTransformMakeScale(1, 1);
            视野显示大小.minimumValue = 0;
            视野显示大小.maximumValue = 1;
            视野显示大小.hidden = NO;
            视野显示大小.value =0.4;
            视野显示大小.continuous =YES;
            // 改变滑条按钮的大小
            NSData *imageData1;
            imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
            thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
            [视野显示大小 setThumbImage:thumbImage forState:UIControlStateNormal];
            [视野显示大小 addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = 视野显示大小;
            
            
            MyLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
            MyLabel6.text = [NSString stringWithFormat:@"%.2f",视野显示大小];
            MyLabel6.numberOfLines = 0;
            MyLabel6.lineBreakMode = NSLineBreakByCharWrapping;
            MyLabel6.textAlignment = NSTextAlignmentCenter;
            MyLabel6.font = [UIFont boldSystemFontOfSize:13];
            MyLabel6.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
            [cell.contentView addSubview:MyLabel6];
        }
        if(indexPath.row==8){
            
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:yaqiang options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

            打击范围大小 = [[UISlider alloc]init];
            cell.textLabel.text = @"打击范围";
            cell.transform = CGAffineTransformMakeScale(1, 1);
            打击范围大小.minimumValue = 0;
            打击范围大小.maximumValue = 500;
            打击范围大小.hidden = NO;
            打击范围大小.value =80;
            打击范围大小.continuous =YES;
            // 改变滑条按钮的大小
            NSData *imageData1;
            imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
            thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
            [打击范围大小 setThumbImage:thumbImage forState:UIControlStateNormal];
            [打击范围大小 addTarget:self action:@selector(yuanquan:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = 打击范围大小;
            
            
            MyLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
            MyLabel7.text = [NSString stringWithFormat:@"%.2f",打击范围大小];
            MyLabel7.numberOfLines = 0;
            MyLabel7.lineBreakMode = NSLineBreakByCharWrapping;
            MyLabel7.textAlignment = NSTextAlignmentCenter;
            MyLabel7.font = [UIFont boldSystemFontOfSize:13];
            MyLabel7.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
            [cell.contentView addSubview:MyLabel7];
        }
        if(indexPath.row==9){
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:yaqiang options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            打击距离大小 = [[UISlider alloc]init];
            cell.textLabel.text = @"打击距离";
            cell.transform = CGAffineTransformMakeScale(1, 1);
            打击距离大小.minimumValue = 0;
            打击距离大小.maximumValue = 500;
            打击距离大小.hidden = NO;
            打击距离大小.value =300;
            打击距离大小.continuous =YES;
            // 改变滑条按钮的大小
            NSData *imageData1;
            imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
            thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
            [打击距离大小 setThumbImage:thumbImage forState:UIControlStateNormal];
            [打击距离大小 addTarget:self action:@selector(jidajuli:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = 打击距离大小;
            
            
            MyLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
            MyLabel8.text = [NSString stringWithFormat:@"%.2f",打击距离大小];
            MyLabel8.numberOfLines = 0;
            MyLabel8.lineBreakMode = NSLineBreakByCharWrapping;
            MyLabel8.textAlignment = NSTextAlignmentCenter;
            MyLabel8.font = [UIFont boldSystemFontOfSize:13];
            MyLabel8.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
            [cell.contentView addSubview:MyLabel8];
            
            
            
        }

    
    if(indexPath.row==10){
        
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:yaqiang options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        命中率大小 = [[UISlider alloc]init];
        cell.textLabel.text = @"追踪命中率";
        cell.transform = CGAffineTransformMakeScale(1, 1);
        命中率大小.minimumValue = 0.8;
        命中率大小.maximumValue = 1;
        命中率大小.hidden = NO;
        命中率大小.value =1;
        命中率大小.continuous =YES;
        // 改变滑条按钮的大小
        NSData *imageData1;
        imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
        thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
        [命中率大小 setThumbImage:thumbImage forState:UIControlStateNormal];
        [命中率大小 addTarget:self action:@selector(mingzhonglv:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = 命中率大小;
        
        
        MyLabel9 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
        MyLabel9.text = [NSString stringWithFormat:@"%.2f",命中率大小];
        MyLabel9.numberOfLines = 0;
        MyLabel9.lineBreakMode = NSLineBreakByCharWrapping;
        MyLabel9.textAlignment = NSTextAlignmentCenter;
        MyLabel9.font = [UIFont boldSystemFontOfSize:13];
        MyLabel9.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
        [cell.contentView addSubview:MyLabel9];
    }
        
        if(indexPath.row==11){
            cell.textLabel.text = @"动态无后";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:beidi options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 无后开关;
            switchView.tag=21;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;

        }
        if(indexPath.row==12){
            cell.textLabel.text = @"动态聚点";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:beidi options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 聚点开关;
            switchView.tag=22;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;

        }
        if(indexPath.row==13){
            cell.textLabel.text = @"动态防抖";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:beidi options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 防抖开关;
            switchView.tag=23;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;

        }
        if(indexPath.row==14){
            cell.textLabel.text = @"超级瞬击";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:beidi options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 瞬击开关;
            switchView.tag=24;
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;

        }
        
        
    }
        
    if(indexPath.section==2){
        if(indexPath.row==0){
            cell.textLabel.text = @"显示枪械";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:qiangxie options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 枪械开关;
            switchView.tag=8;
            switchView.thumbTintColor = [UIColor whiteColor]; // 设置滑块的颜色
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==1){
            cell.textLabel.text = @"显示药品";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:yaopin options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 药品开关;
            switchView.tag=9;
            switchView.thumbTintColor = [UIColor whiteColor]; // 设置滑块的颜色
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==2){
            cell.textLabel.text = @"显示载具";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:zaiju options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 载具开关;
            switchView.tag=10;
            switchView.thumbTintColor = [UIColor whiteColor]; // 设置滑块的颜色
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==3){
            cell.textLabel.text = @"显示配件";
            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:peijian options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UISwitch* switchView = [[UISwitch alloc]init];
            switchView.on = 配件开关;
            switchView.tag=11;
            switchView.thumbTintColor = [UIColor whiteColor]; // 设置滑块的颜色
            [switchView addTarget:self
                           action:@selector(功能开关:)
                 forControlEvents:UIControlEventValueChanged];
            switchView.transform = CGAffineTransformMakeScale(1, 1);
            cell.accessoryView = switchView;
        }
        if(indexPath.row==4){

            NSData *imageData;
            imageData = [[NSData alloc] initWithBase64EncodedString:yaqiang options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:imageData];
            cell.imageView.image=decodedImage;
            CGSize itemSize = CGSizeMake(18, 18);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            物资显示距离 = [[UISlider alloc]init];
            cell.textLabel.text = @"物资距离";
            cell.transform = CGAffineTransformMakeScale(1, 1);
            物资显示距离.minimumValue = 0;
            物资显示距离.maximumValue = 500;
            物资显示距离.hidden = NO;
            物资显示距离.value =80;
            物资显示距离.continuous =YES;
            // 改变滑条按钮的大小
            NSData *imageData1;
            imageData1 = [[NSData alloc] initWithBase64EncodedString:anniu options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *thumbImage = [UIImage imageWithData:imageData1]; // 自定义图片
            thumbImage = [thumbImage resizableImageWithCapInsets:UIEdgeInsetsZero];
            [物资显示距离 setThumbImage:thumbImage forState:UIControlStateNormal];
            [物资显示距离 addTarget:self action:@selector(wuzijuli:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = 物资显示距离;
            
            
            MyLabel9 = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 25, 5, 70, 30)];//70, 5, 70, 30
            MyLabel9.text = [NSString stringWithFormat:@"%.2f",物资显示距离];
            MyLabel9.numberOfLines = 0;
            MyLabel9.lineBreakMode = NSLineBreakByCharWrapping;
            MyLabel9.textAlignment = NSTextAlignmentCenter;
            MyLabel9.font = [UIFont boldSystemFontOfSize:13];
            MyLabel9.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
            [cell.contentView addSubview:MyLabel9];
        }
    }
//    if(indexPath.section==3){
//        if(indexPath.row==0){
//            cell.textLabel.text = @"美化开关";
//            NSData *imageData;
//            imageData = [[NSData alloc] initWithBase64EncodedString:guge options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            UIImage *decodedImage = [UIImage imageWithData:imageData];
//            cell.imageView.image=decodedImage;
//            CGSize itemSize = CGSizeMake(18, 18);
//            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//            [cell.imageView.image drawInRect:imageRect];
//            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            UISwitch* switchView = [[UISwitch alloc]init];
//            switchView.on = 美化开关;
//            switchView.tag=19;
//            switchView.thumbTintColor = [UIColor blueColor]; // 设置滑块的颜色
//            [switchView addTarget:self
//                           action:@selector(功能开关:)
//                 forControlEvents:UIControlEventValueChanged];
//            switchView.transform = CGAffineTransformMakeScale(0.8, 0.8);
//            cell.accessoryView = switchView;
//        }
//        if(indexPath.row==1){
//            cell.textLabel.text = @"人物美化";
//            NSData *imageData;
//            imageData = [[NSData alloc] initWithBase64EncodedString:guge options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            UIImage *decodedImage = [UIImage imageWithData:imageData];
//            cell.imageView.image=decodedImage;
//            CGSize itemSize = CGSizeMake(18, 18);
//            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//            [cell.imageView.image drawInRect:imageRect];
//            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            NSArray *array = [NSArray arrayWithObjects:@"梦幻火箭", @"炽羽金尊", @"初号机", nil];
//            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
//            segment.frame = CGRectMake(0,5,150,30);
//            segment.selectedSegmentIndex = 人物美化;
//            segment.apportionsSegmentWidthsByContent = NO;
//            [segment addTarget:self action:@selector(gongnchange7:) forControlEvents:UIControlEventValueChanged];
//            cell.accessoryView = segment;
//
//        }
//        if(indexPath.row==2){
//            cell.textLabel.text = @"枪械美化";
//            NSData *imageData;
//            imageData = [[NSData alloc] initWithBase64EncodedString:guge options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            UIImage *decodedImage = [UIImage imageWithData:imageData];
//            cell.imageView.image=decodedImage;
//            CGSize itemSize = CGSizeMake(18, 18);
//            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//            [cell.imageView.image drawInRect:imageRect];
//            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            NSArray *array = [NSArray arrayWithObjects:@"M762-甜蜜誓言", @"M416-五爪金龙", @"SCAR-纯梦嫁纱", @"AKM-炫紫旋律", @"98K-伏魔团", @"DP28-枪炮玫瑰", @"M24-翩跹演武", @"M416-至情至圣", nil];
//            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
//            segment.frame = CGRectMake(0,5,150,30);
//            segment.selectedSegmentIndex = 枪械美化;
//            segment.apportionsSegmentWidthsByContent = NO;
//            [segment addTarget:self action:@selector(gongnchange8:) forControlEvents:UIControlEventValueChanged];
//            cell.accessoryView = segment;
//
//        }
//
//    }
    
    
//    }
    return cell;
}


+(void)功能开关:(UISwitch *)jiaa{
    if(jiaa.tag==1){
        if(jiaa.on){
            射线开关=YES;
        }else{
            射线开关=NO;
        }
    }else  if(jiaa.tag==2){
        if(jiaa.on){
            血量开关=YES;
        }else{
            血量开关=NO;
        }
    }else  if(jiaa.tag==3){
        if(jiaa.on){
            名字开关=YES;
        }else{
            名字开关=NO;
        }
    }else  if(jiaa.tag==4){
        if(jiaa.on){
            骨骼开关=YES;
        }else{
            骨骼开关=NO;
        }
        
    }else if(jiaa.tag==5){
        if(jiaa.on){
            持枪开关=YES;
        }else{
            持枪开关=NO;
        }
 }
        else  if(jiaa.tag==7){
        if(jiaa.on){
            自瞄开关=YES;
        }else{
            自瞄开关=NO;
        }
        
    }else if(jiaa.tag==8){
        if(jiaa.on){
            枪械开关=YES;
        }else{
            枪械开关=NO;
        }
    }else  if(jiaa.tag==9){
        if(jiaa.on){
            药品开关=YES;
        }else{
            药品开关=NO;
        }
    }
    else  if(jiaa.tag==10){
        if(jiaa.on){
            载具开关=YES;
        }else{
            载具开关=NO;
        }
    }else  if(jiaa.tag==11){
        if(jiaa.on){
            配件开关=YES;
        }else{
            配件开关=NO;
        }

    }else  if(jiaa.tag==12){
        if(jiaa.on){
            框架开关=YES;
        }else{
            框架开关=NO;
        }
    }else  if(jiaa.tag==13){
        if(jiaa.on){
            雷达开关=YES;
        }else{
            雷达开关=NO;
        }
   }
    else  if(jiaa.tag==16){
        if(jiaa.on){
            倒地开关=YES;
        }else{
            倒地开关=NO;
        }
    }else  if(jiaa.tag==17){
        if(jiaa.on){
            追踪开关=YES;
        }else{
            追踪开关=NO;
        }
    }
    else  if(jiaa.tag==18){
        if(jiaa.on){
            被瞄开关=YES;
        }else{
            被瞄开关=NO;
        }
    }
        else  if(jiaa.tag==19){
        if(jiaa.on){
            美化开关=YES;
        }else{
            美化开关=NO;
        }
    }
    
    else  if(jiaa.tag==20){
        if(jiaa.on){
            背敌模式=YES;
        }else{
            背敌模式=NO;
        }
    }
    else  if(jiaa.tag==21){
        if(jiaa.on){
            无后开关=YES;
        }else{
            无后开关=NO;
        }
    }
    else  if(jiaa.tag==22){
        if(jiaa.on){
            聚点开关=YES;
        }else{
            聚点开关=NO;
        }
    }
    else  if(jiaa.tag==23){
        if(jiaa.on){
            防抖开关=YES;
        }else{
            防抖开关=NO;
        }
    }
    else  if(jiaa.tag==24){
        if(jiaa.on){
            瞬击开关=YES;
        }else{
            瞬击开关=NO;
        }
    }
    
}



+(void)gongnchange1:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        自瞄速度=0.3;
        
    }else if (sender.selectedSegmentIndex == 1) {
        
        自瞄速度=0.6;
    
    }else if (sender.selectedSegmentIndex == 2) {
        
        自瞄速度=1;
        
    }
    
}

+(void)gongnchange2:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        自瞄模式=0;
        
    }else if (sender.selectedSegmentIndex == 1) {
        
        自瞄模式=1;
    
    }else if (sender.selectedSegmentIndex == 2) {
        
        自瞄模式=2;
        
    }
    
}
+(void)gongnchange4:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        圆圈模式=0;
        
    }else if (sender.selectedSegmentIndex == 1) {
        
        圆圈模式=1;
        
    }
}
+(void)gongnchange5:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        自瞄部位=0;
        
    }else if (sender.selectedSegmentIndex == 1) {
        
        自瞄部位=1;
        
    }
}

+(void)gongnchange6:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        框架开关=0;

    }else if (sender.selectedSegmentIndex == 1) {

        框架开关=1;

    }else if (sender.selectedSegmentIndex == 2) {

        框架开关=2;
    }

}
//+(void)gongnchange7:(UISegmentedControl *)sender{
//    if (sender.selectedSegmentIndex == 0) {
//        人物美化=0;
//
//    }else if (sender.selectedSegmentIndex == 1) {
//
//        人物美化=1;
//
//    }else if (sender.selectedSegmentIndex == 2) {
//
//        人物美化=2;
//    }
//
//}
//+(void)gongnchange8:(UISegmentedControl *)sender{
//    if (sender.selectedSegmentIndex == 0) {
//        枪械美化=0;
//        
//    }else if (sender.selectedSegmentIndex == 1) {
//        
//        枪械美化=1;
//        
//    }else if (sender.selectedSegmentIndex == 2) {
//        
//        枪械美化=2;
//    }else if (sender.selectedSegmentIndex == 3) {
//        
//        枪械美化=3;
//        
//    }else if (sender.selectedSegmentIndex == 4) {
//        
//        枪械美化=4;
//    }else if (sender.selectedSegmentIndex == 5) {
//        
//        枪械美化=5;
//        
//    }else if (sender.selectedSegmentIndex == 6) {
//        
//        枪械美化=6;
//    }else if (sender.selectedSegmentIndex == 7) {
//        
//        枪械美化=7;
//    }
//    
//    
//    
//}



+(void)leida:(UISlider *)lei{
    
    雷达大小 = 雷达显示大小.value;
    MyLabel1.text = [NSString stringWithFormat:@"%.2f",雷达显示大小.value];

}
+(void)雷达X轴调节:(UISlider *)lei{
    雷达X = 雷达X轴.value;
    MyLabel2.text = [NSString stringWithFormat:@"%.2f",雷达X轴.value];
}

+(void)雷达Y轴调节:(UISlider *)lei{
    雷达Y = 雷达Y轴.value;
    MyLabel3.text = [NSString stringWithFormat:@"%.2f",雷达Y轴.value];
}

//+(void)预警大小调节:(UISlider *)lei{
//    预警范围 = 预警显示大小.value;
//    MyLabel4.text = [NSString stringWithFormat:@"%.2f",预警显示大小.value];
//}


//+(void)sliderValueChanged:(UISlider *)slider{
//
//    相机视野 = 视野显示大小.value;
//    MyLabel6.text = [NSString stringWithFormat:@"%.2f",视野显示大小.value];
//}

+(void)stepperValueChanged:(UIStepper *)sender {
    压枪速率 = 视野显示大小.value;
    MyLabel6.text = [NSString stringWithFormat:@"%.2f",视野显示大小.value];
}


+(void)yuanquan:(UISlider *)slider{

    圆圈固定 = 打击范围大小.value;
    MyLabel7.text = [NSString stringWithFormat:@"%.2f",打击范围大小.value];
}

+(void)jidajuli:(UISlider *)slider{
    
    击打距离 = 打击距离大小.value;
    MyLabel8.text = [NSString stringWithFormat:@"%.2f",打击距离大小.value];
}

+(void)mingzhonglv:(UISlider *)slider{

    命中率 = 命中率大小.value;
    MyLabel9.text = [NSString stringWithFormat:@"%.2f",命中率大小.value];
}
+(void)wuzijuli:(UISlider *)slider{

    物资距离 = 物资显示距离.value;
    MyLabel9.text = [NSString stringWithFormat:@"%.2f",物资显示距离.value];
        
}


#pragma mark - 行树
+ (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [NcTableView deselectRowAtIndexPath:[NcTableView indexPathForSelectedRow] animated:YES];
}

+ (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 圆角弧度半径
    CGFloat cornerRadius = 20.0f;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    // 显示选中
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init];
    //   创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    //   获取cell的size
    //    第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    
    //      CGRectGetMinY：返回对象顶点坐标
    //      CGRectGetMaxY：返回对象底点坐标
    //      CGRectGetMinX：返回对象左边缘坐标
    //      CGRectGetMaxX：返回对象右边缘坐标
    //      CGRectGetMidX: 返回对象中心点的X坐标
    //      CGRectGetMidY: 返回对象中心点的Y坐标
    //      这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    NSInteger rows = [tableView numberOfRowsInSection:indexPath.section];
    BOOL addLine = NO;
    if (rows == 1) {
        // 初始起点为cell的左侧中间坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
    } else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        addLine = YES;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
        addLine = YES;
    }
    
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    
    // 按照shape layer的path填充颜色，类似于渲染render
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 添加分割线
    if (addLine == YES) {
        
        CALayer *lineLayer = [[CALayer alloc] init];
        
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        
        lineLayer.frame = CGRectMake(18, bounds.size.height-lineHeight, bounds.size.width, lineHeight);
        
        lineLayer.backgroundColor = tableView.separatorColor.CGColor;
        
        [layer addSublayer:lineLayer];
        
    }
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = tableView.separatorColor.CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//==========================控件监听响应======================
+ (void)MsHomeOFFFun{
    菜单控制 = NO;
    [UIView animateWithDuration:0.5 animations:^{
        NcMenuView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [NcMenuView removeFromSuperview];
        
    }];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 当前 VC 支持的屏幕方向
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 优先的屏幕方向
    return UIInterfaceOrientationLandscapeRight;
}


@end
