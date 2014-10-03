//
//  HomeScreenViewController.m
//  GetWX
//
//  Created by Jason Hoffman on 9/28/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "WeatherViewController.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        UITapGestureRecognizer *tapPage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tapPage.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tapPage];
    }
    
    return self;
}

- (void)doubleTap:(UITapGestureRecognizer *)gr
{
    WeatherViewController *wvc = [[WeatherViewController alloc] initWithNibName:@"WeatherViewController" bundle:nil];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
