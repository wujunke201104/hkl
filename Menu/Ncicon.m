//
//  Ncicon.m
//  ENGINE
//
//  Created by DH on 2023/2/3.
//  Shared By @MirWani ..............
//
//死全家的GG爆 狗逼一个 操他妈的血逼
#import "Nctabmenu.h"
#import "Ncicon.h"

//死全家的GG爆 狗逼一个 操他妈的血逼
#define NcKuan  [UIScreen mainScreen].bounds.size.width
#define NcGao [UIScreen mainScreen].bounds.size.height
static UIButton *按钮;
static UIButton *btn;
static NSTimer *防屏蔽;
@implementation Ncicon


static void __attribute__((constructor)) initialize(void)
{
//    NSString *CFBundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
//    if ([CFBundleIdentifier isEqualToString:@"ShadowTrackerExtra"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [Ncicon Mem];
            
        });
//    }
}

+ (void)Mem{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    按钮 = [[UIButton alloc] initWithFrame:CGRectMake(NcKuan-50,30,40,40)];
    [按钮 setTitle:@"" forState:UIControlStateNormal];
    [按钮 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    按钮.backgroundColor = [UIColor clearColor];
    [按钮.titleLabel setFont:[UIFont systemFontOfSize:16]];
    按钮.layer.cornerRadius = 按钮.frame.size.width/2;
    按钮.clipsToBounds = YES;
    [按钮 addTarget:self action:@selector(onConsoleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:ImageTX options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *decodedImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            按钮.layer.contents = (id)decodedImage.CGImage;
        });
    });
    [mainWindow addSubview:按钮];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(TuoDong:)];
    [按钮 addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 2;//点击次数
    tap.numberOfTouchesRequired = 3;//手指数
    [mainWindow addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(tapIconView)];
    
    防屏蔽 = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer*t){
        if(!按钮.hidden) {
            [按钮.superview bringSubviewToFront:按钮];
            UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
            if(按钮.superview != mainWindow) [mainWindow addSubview:按钮];
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [防屏蔽 invalidate];
    });
    
}

+ (void)tapIconView
{
    按钮.hidden = !按钮.hidden;
}

+ (void)TuoDong:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:按钮];
    if(recognizer.state == UIGestureRecognizerStateBegan){
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        按钮.center = CGPointMake(按钮.center.x + translation.x, 按钮.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:按钮];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        CGFloat newX=按钮.center.x;
        CGFloat newY=按钮.center.y;
        按钮.center = CGPointMake(newX, newY);
        [recognizer setTranslation:CGPointZero inView:按钮];
    }
}
//Nctabmenu NcMenuFun
+ (void)onConsoleButtonTapped{
        [Nctabmenu NcMenuFun];
}



@end
