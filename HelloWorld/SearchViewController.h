//
//  SearchViewController.h
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController {

BOOL errorParsing;
	
NSXMLParser *rssParser;
NSMutableArray *articles;
NSMutableDictionary *item;
NSString *currentElement;
NSMutableString *ElementValue;

}

@property (weak, nonatomic) IBOutlet UITextField *ProfileNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *UserNameTxt;
@property (weak, nonatomic) IBOutlet UITableView *SearchTableView;




- (IBAction)BackBtn:(id)sender;
- (IBAction)SearchBtn:(id)sender;
- (void)parseXMLFileAtURL:(NSString *)URL;

@end
