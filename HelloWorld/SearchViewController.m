//
//  SearchViewController.m
//  HelloWorld
//
//  Created by Emi on 30/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "SearchViewController.h"
#import "ModuleViewController.h"
#import "DMSViewController.h"
#import "pdfView.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize UserNameTxt,ProfileNameTxt;

NSString *temp;
int count;
NSString *strName;
NSString *strIDno;
NSString *strLicNO;
NSString *strDocType;
NSString *strVerID;
NSString *strProfileID;
NSString *strDocID;
NSString *strImageName;


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
	count = 0;
	temp = @"";
	
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtn:(id)sender {
	
	DMSViewController *controller = [[DMSViewController alloc]init];
	[self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)SearchBtn:(id)sender
{
    //a-sync or xmlparser
    //http://192.168.2.28/DocufloSDK/docuflosdk.asmx/ProfileSearchMobile?Profile_Name=PPL&Column_Desc=Name|ID%20No&Column_Data=Jacob%20Chin|1
	
	
	[self parseXMLFileAtURL];
	[self.SearchTableView reloadData];
}


#pragma mark - XMLParser

- (void)parseXMLFileAtURL
{
	//NSString *post = @"Profile_Name=PPL&Column_Desc=Name|ID%20No&Column_Data=Jacob%20Chin|1";
     NSString *post = [NSString stringWithFormat:@"Profile_Name=%@&Column_Desc=Name|ID20No&Column_Data=%@|1",@"PPL",UserNameTxt.text];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	
	[request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/ProfileSearchMobile"]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	NSData *xmlFile;
	xmlFile = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
	
	
	articles = [[NSMutableArray alloc] init];
	errorParsing=NO;
	
	rssParser = [[NSXMLParser alloc] initWithData:xmlFile];
	[rssParser setDelegate:self];
	// You may need to turn some of these on depending on the type of XML file you are parsing
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	
	[rssParser parse];
	
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	
	NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
	NSLog(@"Error parsing XML: %@", errorString);
	
	
	errorParsing=YES;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"File found and parsing started");
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
	ElementValue = [[NSMutableString alloc] init];
	if ([elementName isEqualToString:@"DataProfileResult"]) {
		item = [[NSMutableDictionary alloc] init];
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
		ElementValue = [[NSMutableString alloc]initWithString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
//		NSLog(@"%d-set into Item: elementName: %@ ElementValue: %@", count, elementName, ElementValue);
	
		if ([temp isEqualToString:@"Name"] && (![elementName isEqualToString:@"Col_Desc"]  && ![elementName isEqualToString:@"Col_ID"] && ![elementName isEqualToString:@"Col_Name"]) ) {
			strName = ElementValue;
		}
		else if ([temp isEqualToString:@"IDNo"] && (![elementName isEqualToString:@"Col_Desc"]  && ![elementName isEqualToString:@"Col_ID"] && ![elementName isEqualToString:@"Col_Name"]) ) {
			strIDno = ElementValue;
		}
		else if ([temp isEqualToString:@"LicNo"] && (![elementName isEqualToString:@"Col_Desc"]  && ![elementName isEqualToString:@"Col_ID"] && ![elementName isEqualToString:@"Col_Name"]) ) {
			strLicNO = ElementValue;
		}
		else if ([temp isEqualToString:@"DocType"] && (![elementName isEqualToString:@"Col_Desc"]  && ![elementName isEqualToString:@"Col_ID"] && ![elementName isEqualToString:@"Col_Name"]) ) {
			strDocType = ElementValue;
		}
		else if ([elementName isEqualToString:@"VerID"]) {
			strVerID = ElementValue;
		}
		else if ([elementName isEqualToString:@"ProfileID"]) {
			strProfileID = ElementValue;
		}
		else if ([elementName isEqualToString:@"DocID"]) {
			strDocID = ElementValue;
		}
		else if ([elementName isEqualToString:@"ImageName"]) {
			strImageName = ElementValue;
		}
	
		if ([elementName isEqualToString:@"DataProfileResult"]) {
			NSDictionary *tempData = [[NSDictionary alloc] initWithObjectsAndKeys:strName, @"Name", strIDno, @"IDNo", strLicNO, @"LicNo", strDocType, @"DocType", strVerID, @"VerID", strProfileID, @"ProfileID", strDocID, @"DocID", strImageName, @"ImageName",nil];
			[articles addObject:[tempData copy]];
		}
		
		temp = ElementValue;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	if (errorParsing == NO)
	{
		NSLog(@"%@", articles);
		temp = @"";
		NSLog(@"XML processing done!");
	} else {
		NSLog(@"Error occurred during XML processing");
	}
}

#pragma mark - `Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	return [articles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	[[cell.contentView viewWithTag:2001] removeFromSuperview ];
	[[cell.contentView viewWithTag:2002] removeFromSuperview ];
	[[cell.contentView viewWithTag:2003] removeFromSuperview ];
	[[cell.contentView viewWithTag:2004] removeFromSuperview ];
	[[cell.contentView viewWithTag:2005] removeFromSuperview ];
	
	if (articles.count != 0) {
		if(indexPath.row < [articles count]){

			UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 30, 50)];
			label1.text= [[articles objectAtIndex:indexPath.row ]objectForKey:@"ProfileID"];
			label1.tag = 2001;
			[cell.contentView addSubview:label1];
			
			UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(30,0, 100, 50)];
			label2.text= [[articles objectAtIndex:indexPath.row ]objectForKey:@"Name"];
			label2.tag = 2002;
			[cell.contentView addSubview:label2];
			
			UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(150,0, 150, 50)];
			label3.text= [[articles objectAtIndex:indexPath.row ]objectForKey:@"IDNo"];
			label3.tag = 2003;
			[cell.contentView addSubview:label3];
			
			UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(300,0, 100, 50)];
			label4.text= [[articles objectAtIndex:indexPath.row ]objectForKey:@"LicNo"];
			label4.tag = 2004;
			[cell.contentView addSubview:label4];
			
			UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(450,0, 100, 50)];
			label5.text= [[articles objectAtIndex:indexPath.row ]objectForKey:@"ImageName"];
			label5.tag = 2005;
			[cell.contentView addSubview:label5];
		}
	}
	
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"celltext %@", [[articles objectAtIndex:indexPath.row ]objectForKey:@"DocID"]);
    
    NSString *ProfileID = [[articles objectAtIndex:indexPath.row ]objectForKey:@"ProfileID"];
    NSString *VerID = [[articles objectAtIndex:indexPath.row ]objectForKey:@"VerID"];
    NSString *post = [NSString stringWithFormat:@"VerID=%@&DocProfileID=%@&FileType=1",VerID,ProfileID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://192.168.2.28/DocufloSDK/docuflosdk.asmx/ViewFileMobile"]];
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
    NSString *aStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"astr %@",aStr);
    NSArray *Separate = [aStr componentsSeparatedByString:@">"];
    NSString *DEleteAfter = [Separate objectAtIndex:2];
    NSArray  *LastTrim = [DEleteAfter componentsSeparatedByString:@"</string"];
    NSString *LAstURL = [LastTrim objectAtIndex:0];
    NSUserDefaults *pdfURL = [NSUserDefaults standardUserDefaults];
    NSString *Url =LAstURL;
    
    [pdfURL setObject:Url forKey:@"URL"];
    pdfView *viewController = [[pdfView alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

@end
