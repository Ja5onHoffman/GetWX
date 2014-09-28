//
//  HomeScreenViewController.m
//  GetWX
//
//  Created by Jason Hoffman on 9/28/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(/*Next View*/)];
    doubleTap.numberOfTapsRequired = 2;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
