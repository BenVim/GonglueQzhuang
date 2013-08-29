//
//  SFAppDelegate.m
//  Gonglue
//
//  Created by jiajun on 11/24/12.
//  Copyright (c) 2012 Gonglue.com. All rights reserved.
//

#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"
#import "SFAppDelegate.h"
#import "SFLoginService.h"
#import "SFLoginViewController.h"
#import "SFQuestionListViewController.h"
#import "SFSlideNavViewController.h"
#import "UMNavigationController.h"
#import "JSONKit.h" 

#import <sys/socket.h> // Per msqr
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#define NAVIGATION_BAR_BTN_RECT         CGRectMake(0.0f, 0.0f, 38.0f, 30.0f)

@implementation SFAppDelegate

@synthesize navList;

- (void)initURLMapping
{
    NSLog (@"SFAppDelegate->initURLMapping");
    [[UMNavigationController config] setValuesForKeysWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                                     @"SFQuestionListViewController", @"sf://questionlist",
                                                                     @"SFWebViewController", @"http://gonglue.me",
                                                                     @"SFWebViewController", @"http://bbs.gonglue.me",
                                                                     nil]];
}


- (void)initSlideNavigator
{

}


- (void)initNavigators
{
    
    //从远程获得分类列表，然后组成左侧数据
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://bbs.gonglue.me/game.php?mod=api&action=list&gameid=32&deviceid=%@&devicename=%@%@", 
                                       [self getMacAddress],
                                       [[[UIDevice currentDevice] systemName] stringByReplacingOccurrencesOfString:@" " withString:@""],
                                       [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@" " withString:@""]]];

    NSLog(@"Get API Info From %@",url);
    
    //获得接口数据
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:5];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *str = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];

    //解析json
    JSONDecoder *jd=[[JSONDecoder alloc] init];
    NSDictionary *result = [jd objectWithData: returnData];
    for (int i = 0; i < [[result objectForKey:@"category"] count]; i++) {
        NSDictionary *di1 = [[result objectForKey:@"category"] objectAtIndex:i];
        NSString *catname = [di1 objectForKey:@"name"];
        NSString *caturl = [di1 objectForKey:@"url"];
        
        UMNavigationController * tmp = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:caturl] addParams:[NSDictionary dictionaryWithObjectsAndKeys:catname, @"title", @"1", @"login", nil]]];
        NSLog(@"tmp %@", tmp);
        UIButton *nNavBtn = [[UIButton alloc] initWithFrame:NAVIGATION_BAR_BTN_RECT];
        [nNavBtn setBackgroundImage:[UIImage imageNamed:@"nav_menu.png"] forState:UIControlStateNormal];
        [nNavBtn setBackgroundImage:[UIImage imageNamed:@"nav_menu.png"] forState:UIControlStateHighlighted];
        [nNavBtn addTarget:self.navigator action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        nNavBtn.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *nBtnItem = [[UIBarButtonItem alloc] initWithCustomView:nNavBtn];
        tmp.rootViewController.navigationItem.leftBarButtonItem = nBtnItem;
        [tmp.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
        tmp.title = catname;
        
        [self.navList addObject:tmp];
        
        //NSLog (@"----------%@ %@", catname, caturl);
    }

    for(int i = 0; i < [self.navList count]; i++)
    {
       // NSLog (@"----------%d %d %@", i, [self.navList count], [[self.navList objectAtIndex:i] objectForKey:@"title"]);
    }
    self.navigator = nil;
    self.navigator = [[SFSlideNavViewController alloc] initWithItems:@[self.navList]];
    //self.navigator = [[SFSlideNavViewController alloc] initWithItems:@[@[ [self.navList objectAtIndex:0], [self.navList objectAtIndex:1]]]];
    
    
//    self.newestNavigator = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"sf://questionlist"]
//                                                                                          addParams:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                                                     @"最新问题", @"title",
//                                                                                                     @"listnewest", @"list",
//                                                                                                     nil]]];
//    UIButton *nNavBtn = [[UIButton alloc] initWithFrame:NAVIGATION_BAR_BTN_RECT];
//    [nNavBtn setBackgroundImage:[UIImage imageNamed:@"nav_menu.png"] forState:UIControlStateNormal];
//    [nNavBtn setBackgroundImage:[UIImage imageNamed:@"nav_menu.png"] forState:UIControlStateHighlighted];
//    [nNavBtn addTarget:self.navigator action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    nNavBtn.showsTouchWhenHighlighted = YES;
//    UIBarButtonItem *nBtnItem = [[UIBarButtonItem alloc] initWithCustomView:nNavBtn];
//    self.newestNavigator.rootViewController.navigationItem.leftBarButtonItem = nBtnItem;
//    [self.newestNavigator.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    self.newestNavigator.title = @"最新问题";
//     self.navigator = [[SFSlideNavViewController alloc] initWithItems:@[@[self.newestNavigator]]];//,[self.navList objectAtIndex:0]
    
    
    
    
    
    
//    CGRect ViewBG = CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height);
//    UIButton *v_ViewBG = [[UIButton alloc]initWithFrame:ViewBG];
//    v_ViewBG.backgroundColor = [UIColor yellowColor];
//    [v_ViewBG setBackgroundImage:[UIImage imageNamed:@"Default.png"] forState:UIControlStateNormal];
//    [v_ViewBG setBackgroundImage:[UIImage imageNamed:@"Default.png"] forState:UIControlStateHighlighted];
//    [self.window addSubview:v_ViewBG];

    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog (@"SFAppDelegate->didFinishLaunchingWithOptions");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.navList = [NSMutableArray array];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    //self.window.rootViewController = self.viewController;
    //[self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [self initURLMapping];
    [self initNavigators];
    [self initSlideNavigator];
    
    [self.window addSubview:self.navigator.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog (@"SFAppDelegate->applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog (@"SFAppDelegate->applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog (@"SFAppDelegate->applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog (@"SFAppDelegate->applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog (@"SFAppDelegate->applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *strDeviceToken = [NSString stringWithFormat:@"%@", deviceToken];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://bbs.gonglue.me/game.php?mod=api&action=devicetoken&gameid=32&deviceid=%@&devicetoken=%@",
                                       [self getMacAddress],
                                       strDeviceToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"send devicetoken %@", url);
                                                                                        }failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
                                                                                            NSLog(@"Failed: %@",[error localizedDescription]);
                                                                                        }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
    [operation waitUntilFinished];

}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                              message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                              delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (NSString *) getMacAddress
{
	int                    mib[6];
	size_t                len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	// NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
	
}

@end
