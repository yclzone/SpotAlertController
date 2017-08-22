//
//  ViewController.m
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import "ViewController.h"

#import "KGAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UISwitch *sw = [[UISwitch alloc] init];
    [self.view addSubview:sw];
    sw.center = self.view.center;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self systemAlertController];
    [self customAlertController];
}

- (void)customAlertController {
    KGAlertController *av = [KGAlertController alertControllerWithImage:[UIImage imageNamed:@"sheet_call"]
                                                                  title:[[NSAttributedString alloc] initWithString:@"标题"]
                                                                message:[[NSAttributedString alloc] initWithString:@"消息消息消息消息消息消息"]
                                                         preferredStyle:KGAlertControllerStyleAlert];
    
    [av addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入账号";
    }];
    
    [av addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入密码";
        textField.secureTextEntry = YES;
    }];
    
    
    
    KGAlertAction *done = [KGAlertAction actionWithTitle:@"确定"
                                                   style:KGAlertActionStyleDefault handler:^(KGAlertAction *action) {
                                                       NSLog(@"%@", action.title);
                                                   }];
    [av addAction:done];
    
    KGAlertAction *high = [KGAlertAction actionWithTitle:@"删除"
                                                   style:KGAlertActionStyleDestructive handler:^(KGAlertAction *action) {
                                                       NSLog(@"%@", action.title);
                                                   }];
    [av addAction:high];
    
    
    KGAlertAction *cancel = [KGAlertAction actionWithTitle:@"取消"
                                                     style:KGAlertActionStyleCancel handler:^(KGAlertAction *action) {
                                                         NSLog(@"%@", action.title);
                                                     }];
    [av addAction:cancel];
    
    [av show];
}

- (void)systemAlertController {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Title"
                                                                message:@"Message"
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [ac addAction:done];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Hello";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [ac addAction:cancel];
    
    UIAlertAction *other = [UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [ac addAction:other];
    
    
    
    [self presentViewController:ac animated:YES completion:nil];
}


@end
