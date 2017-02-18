//
//  ViewController.m
//  短信验证测试
//
//  Created by 纵昂 on 2017/2/13.
//  Copyright © 2017年 纵昂. All rights reserved.
//

#import "ViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface ViewController ()
//手机号
@property (nonatomic, strong)UITextField * phoneTextField;
//验证码
@property (nonatomic, strong)UITextField * codeTextField;
//获取验证的按钮
@property (nonatomic, strong)UIButton * getCodeBtn;
//进行验证
@property (nonatomic, strong)UIButton * updateCode;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor yellowColor];
    
    
    self.phoneTextField =[[UITextField alloc]initWithFrame:CGRectMake(31, 121, 162, 30)];
    self.phoneTextField.placeholder=@"请输入手机号";
    self.phoneTextField.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:_phoneTextField];
    
    self.codeTextField =[[UITextField alloc]initWithFrame:CGRectMake(31, 174, 162, 30)];
    self.codeTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.codeTextField.placeholder=@"请输入验证码";
    [self.view addSubview:_codeTextField];
    
//     获取验证的按钮
    self.getCodeBtn =[[UIButton alloc]initWithFrame:CGRectMake(213, 120, 100, 30)];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getCodeBtn.backgroundColor=[UIColor blueColor];
    [self.getCodeBtn addTarget:self action:@selector(getBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCodeBtn];
    
//    进行验证
    self.updateCode =[[UIButton alloc]initWithFrame:CGRectMake(231, 173, 100, 30)];
    self.updateCode.backgroundColor=[UIColor blueColor];
    [self.updateCode setTitle:@"尽享验证" forState:UIControlStateNormal];
    [self.updateCode addTarget:self action:@selector(setBton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_updateCode];
}

//  手机号:17615800337   陈威龙：17561913605


#pragma mark - 获取验证码
// 获取验证的按钮
-(void)getBtn{
    __block int timeout =30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {   //倒计时结束
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
//                设置界面的按钮显示 根据自己需求设置
                [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _getCodeBtn.userInteractionEnabled =YES;
            });
        }else{
            int seconds =timeout % 60;
            NSString * starTime =[NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",starTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _getCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
        
    });
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else
        {
            NSLog(@"发送验证码成功");
        }
    }];
    dispatch_resume(_timer);
    
}
#pragma mark - 进行验证码验证
// 进行验证
-(void)setBton{
    
    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.phoneTextField.text zone:@"86" result:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else
        {
            NSLog(@"验证成功");
                  }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
