//
//  BrowseController.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BrowseController.h"
#import "DownloadWebViewController.h"
#import "UIViewUtils.h"
#import "LocaleUtils.h"
#import "StringUtil.h"

@implementation BrowseController
@synthesize browseTextField;
@synthesize wordsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSArray*)getKeywords
{
    if ([LocaleUtils isChina]){
        return [NSArray arrayWithObjects:NSLS(@"www."), NSLS(@".com"), 
                NSLS(@"mp3"), NSLS(@"视频"), NSLS(@"电子书"), NSLS(@"下载"), 
                NSLS(@"音乐"), NSLS(@"相声"), nil];                
    }
    else{
        return [NSArray arrayWithObjects:NSLS(@"www."), NSLS(@".com"), 
         NSLS(@"mp3"), NSLS(@"video"), NSLS(@"download"), nil];        
    }
}

- (NSString*)getSearchEngine
{
    if ([LocaleUtils isChina])
        return @"http://www.baidu.com/s?wd=";
    else
        return @"http://www.google.com/search?q=";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray* keywords = [self getKeywords];
    
    UIButton* keywordTemplateButton = [UIButton buttonWithType:UIButtonTypeCustom];    
    [wordsView createButtonsInView:keywords templateButton:keywordTemplateButton target:self action:@selector(clickKeyword:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self addBlankView:45 currentResponder:browseTextField];    
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setBrowseTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickBrowse:(id)sender
{
    [self.view endEditing:YES];
    
    NSString* searchEngineURL = [self getSearchEngine];    
    NSString* text = browseTextField.text;
    if ([text rangeOfString:@"."].location != NSNotFound){
        if ([text hasPrefix:@"http://"] == NO){
            text = [@"http://" stringByAppendingString:text];
        }
    }
    else{
        text = [searchEngineURL stringByAppendingString:text];
    }
    
    [DownloadWebViewController show:self url:text];
    
}

- (void)clickKeyword:(id)sender
{
    NSString* text = [((UIButton*)sender) currentTitle];
    
    if (browseTextField.text == nil){
        browseTextField.text = text;
    }
    else{
        browseTextField.text = [browseTextField.text stringByAppendingString:text];
    }
}

- (void)dealloc {
    [wordsView release];
    [browseTextField release];
    [super dealloc];
}
@end
