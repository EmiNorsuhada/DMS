//
//  SearchViewController.m
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "SearchViewController.h"
#import "ModuleViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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

- (IBAction)BackBtn:(id)sender {
	
	ModuleViewController *controller = [[ModuleViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)SearchBtn:(id)sender {
	
	NSString *post = @"Profile_Name=PPL&Column_Desc=Name|ID%20No&Column_Data=Jacob%20Chin|1";
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/ProfileSearchMobile"]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if(conn) {
		NSLog(@"Connection Successful");
	} else {
		NSLog(@"Connection could not be made");
	}
	
	NSLog(@"Receive:%d bytes",[urlData length]);
	NSString *aStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
	NSLog(@"aStr value==>%@", aStr);
    
    //http://192.168.2.28/DocufloSDK/docuflosdk.asmx/ProfileSearchMobile?Profile_Name=PPL&Column_Desc=Name|ID%20No&Column_Data=Jacob%20Chin|1
    
    
    
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
	
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
}
@end
