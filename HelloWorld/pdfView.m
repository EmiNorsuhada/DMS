//
//  pdfView.m
//  DocufloMBL
//
//  Created by Emi on 23/4/15.
//  Copyright (c) 2015 tfqnet. All rights reserved.
//

#import "pdfView.h"
#import "SearchViewController.h"

@implementation pdfView

@synthesize BtnClose;


- (void)viewDidLoad {
	
	
	CGRect rect = [[UIScreen mainScreen] bounds];
	CGSize screenSize = rect.size;
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(60,80,screenSize.width,screenSize.height)];
    
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 780, 50)];
    self.navigationItem.title =@"View";
    [self.view addSubview:myBar];
	
	NSUserDefaults *pdfURL = [NSUserDefaults standardUserDefaults];
	NSString *strURL = [pdfURL stringForKey:@"URL"];
	
	NSURL *targetURL = [NSURL URLWithString:strURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
	[webView loadRequest:request];
	
	[self.view addSubview:webView];
	
	BtnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	BtnClose = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, 60, 40)];
	BtnClose.backgroundColor = [UIColor grayColor];
	BtnClose.layer.borderColor = [UIColor blackColor].CGColor;
	BtnClose.layer.borderWidth = 0.5f;
	BtnClose.layer.cornerRadius = 10.0f;
	[BtnClose addTarget:self action:@selector(CloseX) forControlEvents:UIControlEventTouchUpInside];
	[BtnClose setTitle:@"Back" forState:UIControlStateNormal];
	BtnClose.highlighted = YES;
	[BtnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.view addSubview:BtnClose];
	

	
}



-(void)CloseX {
//	NSUserDefaults *pdfURL = [NSUserDefaults standardUserDefaults];
//	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"URL"];
	[self dismissViewControllerAnimated:YES completion: nil];
}

@end
