//
//  ForwardAlert.m
//  ForwardAlertDemo
//
//  Created by Lester on 16/9/12.
//  Copyright © 2016年 Lester-iOS开发:98787555. All rights reserved.
//

#import "ForwardAlert.h"
/** 为了更好地得到View的Top|Bottom|Left|Right*/
#import "UIViewExt.h"

/** 三方Gif*/
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

#define IS_IOS_8_OR_HIGHER ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 8.0 )
/*比例*/
#define prowidht SCREEN_WIDTH / 375

/** 设备的宽高 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/** RGBA*/
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

@interface ForwardAlert(){
    /** title*/
    NSString *alertTitle;
    /** images*/
    NSArray *alertImages;
    /** content*/
    id alertContent;
    /** 内容类型*/
    ContentType contentType;
    /** 接收Block*/
    completionHandlerBlock insideBlock;
}
/** alertView*/
@property (strong, nonatomic) UIView *alertView;
/** 按钮bgView*/
@property (strong, nonatomic) UIView *buttonBgView;
/** text*/
@property (strong, nonatomic) UITextField *promptTextField;
/** 个人转发*/
@property (strong, nonatomic) UIView *personalForwardView;
/** 群组转发*/
@property (strong, nonatomic) UIScrollView *groupForwardView;
/** content*/
@property (strong, nonatomic) UIView *contentView;
@end

@implementation ForwardAlert

-(instancetype)initWithTitle:(NSString *)title images:(NSArray *)images content:(id)content contentType:(ContentType)type buttonHandler:(completionHandlerBlock)completionHandler{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if(self){
        /** 1.接收参数和设置self属性*/
        alertTitle = title;
        alertImages = images;
        alertContent = content;
        insideBlock = completionHandler;
        contentType = type;
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        
        /** 2.添加AlertView*/
        [self addSubview:self.alertView];
        /** 3.监听键盘*/
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

-(void)show{
    UIView *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.alpha = .6;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
        
    } completion:^(BOOL finished){
        /** 显示完成 可做代理回调*/
        
    }];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.bottom = rect.origin.y - 30;
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)notif {
    [self setAlertFrame];
}

#pragma mark - 懒加载
- (UIView *)alertView{
    if(!_alertView){
        _alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - (SCREEN_WIDTH - 60))/2, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 60, 300)];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 4;
        _alertView.layer.masksToBounds = YES;
        
        UILabel *fsTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, _alertView.frame.size.width - 30, 16)];
        fsTitleLabel.text = @"发送给:";
        fsTitleLabel.font = [UIFont systemFontOfSize:15.f];
        [_alertView addSubview:fsTitleLabel];
        
        /** 1.判断转发类型*/
        if (alertImages.count<2) {
            /** 个人转发*/
            [self.alertView addSubview:self.personalForwardView];
        }
        else
        {
            /** 群组转发*/
            [self.alertView addSubview:self.groupForwardView];
        }
        
        /** 2.添加内容*/
        [self.alertView addSubview:self.contentView];
        
        /** 3.添加TextField*/
        [self.alertView addSubview:self.promptTextField];
        
        /** 4.创建底部按钮bgView*/
        self.buttonBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.promptTextField.bottom + 30, self.alertView.frame.size.width, prowidht * 45)];
        [self.alertView addSubview:self.buttonBgView];
        /** 5.创建按钮*/
        [self createButtons];
        
        /** 6.载入完UI后 重新刷新Alert的Frame*/
        [self setAlertFrame];
        
    }
    return _alertView;
}
- (UITextField *)promptTextField
{
    if(!_promptTextField){
        CGFloat y = self.contentView.bottom + 10;
        _promptTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, y, self.alertView.frame.size.width - 30, prowidht * 32)];
        _promptTextField.layer.cornerRadius = 2;
        _promptTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _promptTextField.placeholder = @" 给TA留言";
        _promptTextField.font = [UIFont systemFontOfSize:15.f];
    }
    return _promptTextField;
}
- (UIView *)personalForwardView{
    if(!_personalForwardView){
        _personalForwardView = [[UIView alloc]initWithFrame:CGRectMake(0, /*发送给的X+发送给的高度+距离发送给的间隔*/25 + 16 + 10, self.alertView.frame.size.width, prowidht * 50)];
        
        /** 头像*/
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, (self.alertView.frame.size.width - 30)/6, (self.alertView.frame.size.width - 30)/6)];
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        [_personalForwardView addSubview:imageView];
        
        if(![self matchHttp:alertImages[0]]){
            imageView.image = [UIImage imageNamed:alertImages[0]];
        }
        else{
            /** http||Https 网络图片*/
            
        }
        
        /** 用户名*/
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 15, (prowidht * 50 - 15)/2, self.alertView.frame.size.width - imageView.right - 15 - 15, 15)];
        contentLabel.font = [UIFont systemFontOfSize:14.f];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.text = alertTitle;
        [_personalForwardView addSubview:contentLabel];
        
    }
    return _personalForwardView;
}

/**
 *  获得群组转发的头像视图 创建了6行6列的头像控件
 */
- (UIScrollView *)groupForwardView{
    if(!_groupForwardView){
        _groupForwardView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, /*发送给的X+发送给的高度+距离发送给的间隔*/25 + 16 + 10, self.alertView.frame.size.width, alertImages.count>6?prowidht * 50 * 2:prowidht * 50)];
        
        CGFloat start_X = 15.0f;           // 第一个按钮的X坐标
        CGFloat start_Y = 0.f;      // 第一个按钮的Y坐标
        CGFloat width_Space = 5.0f;        // 2个按钮之间的横间距
        CGFloat height_Space = 5.f ;     // 竖间距
        CGFloat button_Height = (self.alertView.frame.size.width - 30 - width_Space * 5)/6;    // 高
        CGFloat button_width = (self.alertView.frame.size.width - 30 - width_Space * 5)/6;      // 宽
        /** 创建Item*/
        for(NSInteger i =0; i < alertImages.count; i ++){
            NSInteger index = i % 6;
            NSInteger page = i / 6;
            
            /** 头像*/
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index * (button_width + width_Space) + start_X, page  * (button_Height + height_Space)+start_Y, button_width, button_Height)];
            imageView.layer.cornerRadius = 3;
            if(![self matchHttp:alertImages[i]]){
                imageView.image = [UIImage imageNamed:alertImages[i]];
            }
            else{
                /** 网络图片*/
                
            }
            imageView.layer.masksToBounds = YES;
            [_groupForwardView addSubview:imageView];
        }
        
    }
    return _groupForwardView;
}

/**
 *  得到contentView(内容视图：文本||图片||Gif)  并计算content的高度
 */
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, alertImages.count>6?self.groupForwardView.bottom:self.personalForwardView.bottom + 10, self.alertView.frame.size.width, 0)];
        CGRect contentFrame = CGRectMake(0, alertImages.count>6?self.groupForwardView.bottom:self.personalForwardView.bottom + 10, self.alertView.frame.size.width, 0);
        if(contentType==Content_Image){
            contentFrame.size.height = prowidht * 150;
            
            /** 创建图片*/
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, self.alertView.frame.size.width - 30, prowidht * 150)];
            if(![self matchHttp:alertContent]){
                imageView.image = [UIImage imageNamed:alertContent];
            }
            else{
                /** 网络图片*/
                
            }
            [_contentView addSubview:imageView];
        }
        else if (contentType==Content_Text){
            contentFrame.size.height = [self getHeight]/14<2?20:40;
            
            /** 文字*/
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.alertView.frame.size.width - 30, contentFrame.size.height)];
            contentLabel.font = [UIFont systemFontOfSize:14.f];
            contentLabel.textColor = [UIColor lightGrayColor];
            contentLabel.numberOfLines = [self getHeight]/14<=2?[self getHeight]/14:2;
            contentLabel.text = alertContent;
            [_contentView addSubview:contentLabel];
        }
        else if (contentType==Content_Gif){
            /** gif*/
            contentFrame.size.height = prowidht * 150;
            
            /** 创建图片*/
            FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(15, 0, self.alertView.frame.size.width - 30, prowidht * 150)];
            gifImageView.contentMode = UIViewContentModeScaleAspectFill;
            gifImageView.clipsToBounds = YES;
            NSURL *url1 = [[NSBundle mainBundle] URLForResource:alertContent withExtension:@"gif"];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
            gifImageView.animatedImage = animatedImage1;
            
            [_contentView addSubview:gifImageView];
        }
        self.contentView.frame = contentFrame;

      
    }
    return _contentView;
}

#pragma mark - create Default UI
- (void)createButtons{
    NSArray *titles = @[@"取消",@"确定"];
    for(NSInteger i = 0; i < 2; i++){
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(i * (self.alertView.frame.size.width / 2), 0, self.alertView.frame.size.width / 2, prowidht * 45);
        [itemBtn setTitle:titles[i] forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:[self buttonImageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.tag = i + 10;
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [itemBtn setBackgroundImage:[self buttonImageFromColor:[UIColor groupTableViewBackgroundColor]] forState:UIControlStateHighlighted];
        [itemBtn setTitleColor:i==0?[UIColor blackColor]:[UIColor cyanColor] forState:UIControlStateNormal];
        [self.buttonBgView addSubview:itemBtn];
        
        if(i){
            /** 顶部线条*/
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width, 0.8)];
            topLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.buttonBgView addSubview:topLine];
            
            /** 间隔线*/
            UIView *spaceLine = [[UIView alloc]initWithFrame:CGRectMake(self.alertView.frame.size.width / 2, 0, 0.8, prowidht * 45)];
            spaceLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.buttonBgView addSubview:spaceLine];
        }
    }
}

/** 
 *  刷新alertView Frame
 */
- (void)setAlertFrame{
    /** 1.更新高度*/
    self.alertView.height = self.buttonBgView.bottom;
    /** 2.设置居中显示*/
    self.alertView.top = (SCREEN_HEIGHT - self.buttonBgView.bottom)/2;
}

#pragma mark - Button Action
- (void)buttonAction:(UIButton *)button{
    [self removeFromSuperview];
    
    if(insideBlock){
        insideBlock(button.tag - 10);
    }
}

#pragma mark - utils
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

-(BOOL)matchHttp:(NSString *)str
{
    // 判断是否以字母开头
    if ([str hasPrefix:@"http"]||[str hasPrefix:@"https"]) {
        return YES;
    } else {
        return NO;
    }
}

-(CGFloat)getHeight {
    NSDictionary *attrDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]};
    CGRect strRect = [alertContent boundingRectWithSize:CGSizeMake(self.alertView.frame.size.width - 30,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil];
    
    return strRect.size.height;
}

#pragma mark - notification
-(void)dealloc{
    /** 删除通知中心*/
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
