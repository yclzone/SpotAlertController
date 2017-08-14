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
    
    KGAlertController *av = [KGAlertController alertControllerWithImage:[UIImage imageNamed:@"sheet_call"]
                                                                  title:[[NSAttributedString alloc] initWithString:@"标题"]
                                                                message:[[NSAttributedString alloc] initWithString:@"消息消息消息消息消息消息"]
                                                         preferredStyle:KGAlertControllerStyleAlert];
    
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


@end
