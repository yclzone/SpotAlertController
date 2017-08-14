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
    KGAlertController *av = [KGAlertController alertControllerWithTitle:[[NSAttributedString alloc] initWithString:@"Warrning"]
                                                                message:[[NSAttributedString alloc] initWithString:@"Message"]
                                                         preferredStyle:KGAlertControllerStyleAlert];
    
    KGAlertAction *done = [KGAlertAction actionWithTitle:@"确定" handler:^(KGAlertAction *action) {
        NSLog(@"%@", action.title);
    }];
    [av addAction:done];
    
    KGAlertAction *cancel = [KGAlertAction actionWithTitle:@"取消" handler:^(KGAlertAction *action) {
        NSLog(@"%@", action.title);
    }];
    [av addAction:cancel];
    
    
    
    
    [av show];
}


@end
