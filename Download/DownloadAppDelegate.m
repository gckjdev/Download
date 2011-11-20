//
//  DownloadAppDelegate.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadAppDelegate.h"
#import "UIUtils.h"
#import "ReviewRequest.h"
#import "DeviceDetection.h"
#import "UINavigationBarExt.h"

#import "BrowseController.h"
#import "DownloadManageController.h"
#import "TopDownloadController.h"
#import "ResourceCategoryController.h"
#import "AboutController.h"

#import "DownloadService.h"
#import "ResourceService.h"

NSString* GlobalGetServerURL()
{
    //   return @"http://192.168.1.101:8000/api/i?";
    
    // return @"http://uhz001030.chinaw3.com/api/i?";
    
    
    return @"http://192.168.1.188:8000/api/i?";
    
}


@implementation DownloadAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize dataManager;
@synthesize reviewRequest;

- (NSString *)appKey
{
    return kMobClickKey;
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (void)initTabViewControllers
{
    
    self.tabBarController = [[[PPTabBarController alloc] init] autorelease];
    
    self.tabBarController.delegate = self;
    [self.tabBarController setBarBackground:@"tu_209.png"];
    [self.tabBarController setTextColor:[UIColor colorWithRed:194/255.0 green:188/255.0 blue:180/255.0 alpha:1.0]
                   selectTextColor:[UIColor colorWithRed:210/255.0 green:217/255.0 blue:133/255.0 alpha:1.0]];
    self.tabBarController.buttonStyle = TAB_BUTTON_STYLE_ICON;    
    self.tabBarController.selectedIndex = 0;
    
	NSMutableArray* controllers = [[NSMutableArray alloc] init];
    
	[UIUtils addViewController:[TopDownloadController alloc]
					 viewTitle:NSLS(@"kFirstViewTitle")
					 viewImage:@"tu_06.png"
			  hasNavController:YES			
			   viewControllers:controllers];	
    
	[UIUtils addViewController:[ResourceCategoryController alloc]
					 viewTitle:NSLS(@"kSecondViewTitle")
					 viewImage:@"tu_07.png"
			  hasNavController:YES			
			   viewControllers:controllers];	
    
	[UIUtils addViewController:[BrowseController alloc]
                     viewTitle:NSLS(@"kThirdViewTitle")				 
                     viewImage:@"tu_10.png"
              hasNavController:YES			
               viewControllers:controllers];

	[UIUtils addViewController:[DownloadManageController alloc]
					 viewTitle:NSLS(@"kFourthViewTitle")				 
					 viewImage:@"tu_12.png"
			  hasNavController:YES			
			   viewControllers:controllers];	
	    
    [UIUtils addViewController:[AboutController alloc]
                     viewTitle:NSLS(@"Settings")
                     viewImage:@"tu_13.png"
              hasNavController:YES			
               viewControllers:controllers];	        
    
    [self.tabBarController setSelectedImageArray:[NSArray arrayWithObjects:
                                                  @"tu_21.png", 
                                                  @"tu_22.png", 
                                                  @"tu_23.png", 
                                                  @"tu_24.png", 
                                                  @"tu_25.png", nil]];
    	
	self.tabBarController.viewControllers = controllers;	
	[controllers release];
}

- (void)initMobClick
{
    [MobClick setDelegate:self reportPolicy:BATCH];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[WebViewTouchWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self initTabViewControllers];
    
    self.dataManager = [[CoreDataManager alloc] initWithDBName:kDbFileName dataModelName:nil];
//    workingQueue = dispatch_queue_create("main working queue", NULL);    
    
    // init service
    [DownloadService defaultService];   
    [ResourceService defaultService];
	[self initMobClick];
    
    // test

    // Ask For Review
	self.reviewRequest = [ReviewRequest startReviewRequest:kAppId appName:GlobalGetAppName() isTest:NO];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    // init iCloud
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"AppDelegate: iCloud access!");
//        [self loadDocument];
    } else {
        NSLog(@"AppDelegate: No iCloud access (either you are using simulator or, if you are on your phone, you should check settings");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    [MobClick appTerminated];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [[NSUserDefaults standardUserDefaults] synchronize];
//	[self releaseResourceForAllViewControllers];	
    
    [[DownloadService defaultService] pauseAllDownloadItem];
    
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (UIBackgroundTaskInvalid != backgroundTask) {
                [application endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    NSLog(@"Background Task Remaining Time = %f", [application backgroundTimeRemaining]);
    if (UIBackgroundTaskInvalid != backgroundTask) {
    }		

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    [MobClick appLaunched];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    [MobClick appTerminated];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
