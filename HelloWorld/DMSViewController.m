//
//  DMSViewController.m
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "DMSViewController.h"
#import "ModuleViewController.h"

@interface DMSViewController ()

@end

@implementation DMSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginBtn:(id)sender {
	
	ModuleViewController *controller = [[ModuleViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}
@end
