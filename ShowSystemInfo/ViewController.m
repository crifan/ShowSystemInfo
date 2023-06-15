//
//  ViewController.m
//  ShowSystemInfo
//
//  Created by licrifan on 2022/11/4.
//

#import "ViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import <sys/types.h>
#import <sys/sysctl.h>

// Mobile Gestalt EquipmentInfo
extern CFTypeRef MGCopyAnswer(CFStringRef);
//static CFStringRef (*$MGCopyAnswer)(CFStringRef);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)carrierBtnClicked:(UIButton *)sender {
    NSLog(@"carrier button clicked");

    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSDictionary<NSString *, CTCarrier *> *providers= [networkInfo serviceSubscriberCellularProviders];
    CTCarrier *carrier = providers.allValues.firstObject;

    BOOL allowVoip = carrier.allowsVOIP;
    _allowVoipLbl.text = allowVoip ? @"Yes":@"No";

    NSString* carrierName = carrier.carrierName;
    _carrierNameLbl.text = carrierName;

    NSString* isoCountryCode = carrier.isoCountryCode;
    _iccLbl.text = isoCountryCode;
    
    NSString* mobileCountryCode = carrier.mobileCountryCode;
    _mccLbl.text = mobileCountryCode;

    NSString* mobileNetworkCode = carrier.mobileNetworkCode;
    _mncLbl.text = mobileNetworkCode;
}


// StatusBar Celluar/Network Service String
+ (NSString*) getStatusBarCelluarStr
{
    //    id statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    //    if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
    //        infoArray = [[[statusBar valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    //    } else {
    //        infoArray = [[statusBar valueForKey:@"foregroundView"] subviews];
    //    }
        
    //    UIView *statusBar = nil;
    //    if (@available(iOS 13.0, *)) {
    //        // iOS 13  弃用keyWindow属性  从所有windowl数组中取
    //        statusBar = [[UIView alloc]initWithFrame:[UIApplication 　　　　sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
    //    } else {
    //        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    //    }

    NSString *serviceString = @"?";

    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        id _statusBar = nil;
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *_localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([_localStatusBar respondsToSelector:@selector(statusBar)]) {
                _statusBar = [_localStatusBar performSelector:@selector(statusBar)];
                if (_statusBar) {
                     // _UIStatusBarDataCellularEntry
                     id currentData = [[_statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
//                     id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
                     id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
                    
                    /*
                         typedef NS_ENUM(NSUInteger, LLNetworkStatus) {
                             LLNetworkStatusNotReachable = 0,
                             LLNetworkStatusReachableViaWiFi,
                             LLNetworkStatusReachableViaWWAN,
                             LLNetworkStatusReachableViaWWAN2G,
                             LLNetworkStatusReachableViaWWAN3G,
                             LLNetworkStatusReachableViaWWAN4G
                         };
                     */
                    
//                     if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
//                         // If wifiEntry is enabled, is WiFi.
////                         serviceString = LLNetworkStatusReachableViaWiFi;
//                         serviceString = @"WiFi";
//                     } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                    
                    if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                        NSString* celluarStr = [_cellularEntry valueForKeyPath:@"string"];
                        serviceString = celluarStr;
//                         NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
//                         if (type) {
//                             switch (type.integerValue) {
//                                 case 0:
//                                     // Return 0 when no sim card.
////                                     serviceString = LLNetworkStatusNotReachable;
////                                     serviceString = @"No Sim Card";
//                                     serviceString = @"无SIM卡";
//                                 case 1: // Return 1 when 1G.
//                                     serviceString = @"WiFi";
//                                     break;
//                                 case 2:
//                                     serviceString = @"1G";
//                                     break;
//                                 case 3:
//                                     serviceString = @"2G";
//                                     break;
//                                 case 4:
////                                     serviceString = LLNetworkStatusReachableViaWWAN3G;
//                                     serviceString = @"3G";
//                                     break;
//                                 case 5:
////                                     serviceString = LLNetworkStatusReachableViaWWAN4G;
//                                     serviceString = @"4G";
//                                     break;
////                                 default:
//////                                     serviceString = LLNetworkStatusReachableViaWWAN;
////                                     serviceString = @"1G/2G";
////                                     break;
//                             }
//                         }
                     }
                 }
             }
        }
    } else {
        NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        for (id info in infoArray)
        {
            if ([info isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")])
            {
                serviceString = [info valueForKeyPath:@"serviceString"];
//                NSLog(@"运营商名称：%@", serviceString);
            }
        }
    }
    
    return serviceString;
};

- (IBAction)statusCarrierBtnClicked:(UIButton *)sender {
    NSString *serviceString = @"?";
    serviceString = [ViewController getStatusBarCelluarStr];
    _statusServiceStrLbl.text = serviceString;
}

- (IBAction)nameBtnClicked:(UIButton *)sender {
    NSLog(@"name button clicked");

    NSString *curDevName = [[UIDevice currentDevice] name];
    NSLog(@"curDevName=%@", curDevName);
    _nameLbl.text = curDevName;
}

- (IBAction)systemNameBtnClicked:(UIButton *)sender {
    NSLog(@"systemName button clicked");

    NSString *curSysName = [[UIDevice currentDevice] systemName];
    NSLog(@"curSysName=%@", curSysName);
    _systemNameLbl.text = curSysName;
}

- (IBAction)sysVerCBtnlicked:(UIButton *)sender {
    NSLog(@"systemVersion button clicked");

    NSString *curSysVer = [[UIDevice currentDevice] systemVersion];
    NSLog(@"curSysVer=%@", curSysVer);
    _systemVersionLbl.text = curSysVer;
}

- (IBAction)modelBtnClicked:(UIButton *)sender {
    NSLog(@"model button clicked");

    NSString *curDevModel = [[UIDevice currentDevice] model];

    _modelLbl.text = curDevModel;
}

typedef enum
{
    GenerationIndex,   //0
    VariantIndex,      //1
    ANumberIndex,      //2
} DeviceModelIndex;

static NSString *const Unknown = @"-";

-(NSDictionary*)machineIdMapDict
{
    // https://stackoverflow.com/questions/18414032/how-to-identify-a-hw-machine-identifier-reliable
    // https://www.theiphonewiki.com/wiki/Models
    return @{
        // Identifier : [Generation, versions? , "A" Number=CPU type ?]
         //iPad.
         @"iPad1,1" : @[ @"iPad 1G", @"Wi-Fi / GSM", @"A1219 / A1337" ],
         @"iPad2,1" : @[ @"iPad 2", @"Wi-Fi", @"A1395" ],
         @"iPad2,2" : @[ @"iPad 2", @"GSM", @"A1396" ],
         @"iPad2,3" : @[ @"iPad 2", @"CDMA", @"A1397" ],
         @"iPad2,4" : @[ @"iPad 2", @"Wi-Fi Rev A", @"A1395" ],
         @"iPad2,5" : @[ @"iPad mini", @"Wi-Fi", @"A1432" ],
         @"iPad2,6" : @[ @"iPad mini", @"GSM", @"A1454" ],
         @"iPad2,7" : @[ @"iPad mini", @"GSM+CDMA", @"A1455" ],
         @"iPad3,1" : @[ @"iPad 3", @"Wi-Fi", @"A1416" ],
         @"iPad3,2" : @[ @"iPad 3", @"GSM+CDMA", @"A1403" ],
         @"iPad3,3" : @[ @"iPad 3", @"GSM", @"A1430" ],
         @"iPad3,4" : @[ @"iPad 4", @"Wi-Fi", @"A1458" ],
         @"iPad3,5" : @[ @"iPad 4", @"GSM", @"A1459" ],
         @"iPad3,6" : @[ @"iPad 4", @"GSM+CDMA", @"A1460" ],
         @"iPad4,1" : @[ @"iPad Air", @"Wi‑Fi", @"A1474" ],
         @"iPad4,2" : @[ @"iPad Air", @"Cellular", @"A1475" ],
         @"iPad4,4" : @[ @"iPad mini 2", @"Wi‑Fi", @"A1489" ],
         @"iPad4,5" : @[ @"iPad mini 2", @"Cellular", @"A1517" ],
         @"iPad4,6" : @[ @"iPad mini 2", @"N/A", @"A1491" ],
         @"iPad4,7" : @[ @"iPad mini 3", @"N/A", @"A1599" ],
         @"iPad4,8" : @[ @"iPad mini 3", @"N/A", @"A1600" ],
         @"iPad4,9" : @[ @"iPad mini 3", @"N/A", @"A1601" ],
         @"iPad5,3" : @[ @"iPad Air 2", @"N/A", @"A1566" ],
         @"iPad5,4" : @[ @"iPad Air 2", @"N/A", @"A1567" ],

         //iPhone.
         @"iPhone1,1" : @[ @"iPhone 2G", @"GSM", @"A1203" ],
         @"iPhone1,2" : @[ @"iPhone 3G", @"GSM", @"A1241 / A13241" ],
         @"iPhone2,1" : @[ @"iPhone 3GS", @"GSM", @"A1303 / A13251" ],
         @"iPhone3,1" : @[ @"iPhone 4", @"GSM", @"A1332" ],
         @"iPhone3,2" : @[ @"iPhone 4", @"GSM Rev A", @"-" ],
         @"iPhone3,3" : @[ @"iPhone 4", @"CDMA", @"A1349" ],
         @"iPhone4,1" : @[ @"iPhone 4S", @"GSM+CDMA", @"A1387 / A14311" ],
         @"iPhone5,1" : @[ @"iPhone 5", @"GSM", @"A1428" ],
         @"iPhone5,2" : @[ @"iPhone 5", @"GSM+CDMA", @"A1429 / A14421" ],
         @"iPhone5,3" : @[ @"iPhone 5C", @"GSM", @"A1456 / A1532" ],
         @"iPhone5,4" : @[ @"iPhone 5C", @"Global", @"A1507 / A1516 / A1526 / A1529" ],
         @"iPhone6,1" : @[ @"iPhone 5S", @"GSM", @"A1433 / A1533" ],
         @"iPhone6,2" : @[ @"iPhone 5S", @"Global", @"A1457 / A1518 / A1528 / A1530" ],
         @"iPhone7,2" : @[ @"iPhone 6", @"N/A", @"A1549 / A1586" ],
         @"iPhone7,1" : @[ @"iPhone 6 Plus", @"N/A", @"A1522 / A1524" ],
         // added by Crifan Li, 20211014
         @"iPhone8,1" : @[ @"iPhone 6s", @"N/A", @"A1633 / A1688 / A1691 / A1700" ],
         @"iPhone8,2" : @[ @"iPhone 6s Plus", @"N/A", @"A1634 / A1687 / A1690 / A1699" ],
         @"iPhone8,4" : @[ @"iPhone SE (1st generation)", @"N/A", @"A1662 / A1723 / A1724" ],
         @"iPhone9,1" : @[ @"iPhone 7", @"N/A", @"A1660 / A1779 / A1780" ],
         @"iPhone9,3" : @[ @"iPhone 7", @"N/A", @"A1778" ],
         @"iPhone9,2" : @[ @"iPhone 7 Plus", @"N/A", @"A1661 / A1785 / A1786" ],
         @"iPhone9,4" : @[ @"iPhone 7 Plus", @"N/A", @"A1784" ],
         @"iPhone10,1" : @[ @"iPhone 8", @"N/A", @"A1863 / A1906 / A1907" ],
         @"iPhone10,4" : @[ @"iPhone 8", @"N/A", @"A1905" ],
         @"iPhone10,2" : @[ @"iPhone 8 Plus", @"N/A", @"A1864 / A1898 / A1899" ],
         @"iPhone10,5" : @[ @"iPhone 8 Plus", @"N/A", @"A1897" ],
         @"iPhone10,3" : @[ @"iPhone X", @"N/A", @"A1865 / A1902" ],
         @"iPhone10,6" : @[ @"iPhone X", @"N/A", @"A1901" ],
         @"iPhone11,8" : @[ @"iPhone XR", @"N/A", @"A1984 / A2105 / A2106 / A2108" ],
         @"iPhone11,2" : @[ @"iPhone XS", @"N/A", @"A1920 / A2097 / A2098 / A2100" ],
         @"iPhone11,6" : @[ @"iPhone XS Max", @"N/A", @"A1921 / A2101 / A2102 / A2104" ],
         @"iPhone11,4" : @[ @"iPhone XS Max", @"N/A", @"A2103" ],
         @"iPhone12,1" : @[ @"iPhone 11", @"N/A", @"A2111 / A2221 / A2223" ],
         @"iPhone12,3" : @[ @"iPhone 11 Pro", @"N/A", @"A2160 / A2215 / A2217" ],
         @"iPhone12,5" : @[ @"iPhone 11 Pro Max", @"N/A", @"A2161 / A2220 / A2218" ],
         @"iPhone12,8" : @[ @"iPhone SE (2nd generation)", @"N/A", @"A2275 / A2296 / A2298" ],
         @"iPhone13,1" : @[ @"iPhone 12 mini", @"N/A", @"A2176 / A2398 / A2400 / A2399" ],
         @"iPhone13,2" : @[ @"iPhone 12", @"N/A", @"A2172 / A2402 / A2404 / A2403" ],
         @"iPhone13,3" : @[ @"iPhone 12 Pro", @"N/A", @"A2341 / A2406 / A2407 / A2408" ],
         @"iPhone13,4" : @[ @"iPhone 12 Pro Max", @"N/A", @"A2342 / A2410 / A2411 / A2412" ],
         @"iPhone14,4" : @[ @"iPhone 13 mini", @"N/A", @"A2481 / A2626 / A2629 / A2630 / A2628" ],
         @"iPhone14,5" : @[ @"iPhone 13", @"N/A", @"A2482 / A2631 / A2634 / A2635 / A2633" ],
         @"iPhone14,2" : @[ @"iPhone 13 Pro", @"N/A", @"A2483 / A2636 / A2639 / A2640 / A2638" ],
         @"iPhone14,3" : @[ @"iPhone 13 Pro Max", @"N/A", @"A2484 / A2641 / A2644 / A2645 / A2643" ],

         //iPod.
         @"iPod1,1" : @[ @"iPod touch 1G", @"-", @"A1213" ],
         @"iPod2,1" : @[ @"iPod touch 2G", @"-", @"A1288" ],
         @"iPod3,1" : @[ @"iPod touch 3G", @"-", @"A1318" ],
         @"iPod4,1" : @[ @"iPod touch 4G", @"-", @"A1367" ],
         @"iPod5,1" : @[ @"iPod touch 5G", @"-", @"A1421 / A1509" ]
    };
}

/* get hw.machine by call sysctlbyname */
NSString * getHwMachine(void) {
    NSString *deviceModel = NULL;

    // sysctl hw.machine
    size_t realReturnValueSize = 0;
    int firstCallRetValue = sysctlbyname("hw.machine", NULL, &realReturnValueSize, NULL, 0);
    NSLog(@"firstCallRetValue=%d, realReturnValueSize=%zu", firstCallRetValue, realReturnValueSize);
    if (realReturnValueSize > 0) {
        char *modelStr = malloc(realReturnValueSize);
        NSLog(@"after malloc: modelStr=%p", modelStr);

    //    unsigned long lastPosition = realReturnValueSize - 1; // 10
    //    NSLog(@"lastPosition=%zu", lastPosition);
    //    for (int i = 0; i < realReturnValueSize; i++)
    //    {
    //        modelStr[i] = 'x';
    //    }
    //    NSLog(@"after set all char: modelStr=%s", modelStr);
    //    *(modelStr + lastPosition) = '\0';
    //    NSLog(@"after set last pos: modelStr=%s", modelStr);

        int secondCallRetValue = sysctlbyname("hw.machine", modelStr, &realReturnValueSize, NULL, 0);
        NSLog(@"after 2nd sysctlbyname: modelStr=%s, secondCallRetValue=%d", modelStr, secondCallRetValue);
        deviceModel = [NSString stringWithCString:modelStr encoding:NSUTF8StringEncoding];
        NSLog(@"deviceModel=%@", deviceModel);
        free(modelStr);
    } else {
        NSLog(@"Failed to first time use sysctlbyname(hw.machine) to get return size");
    }
    
   return deviceModel;
}

- (IBAction)sysctlBtnClicked:(UIButton *)sender {
    NSString *curHwMachine = getHwMachine();
    NSLog(@"curHwMachine=%@", curHwMachine);
    _hwMachineLbl.text = curHwMachine;

    NSArray *devInfoArr = [self.machineIdMapDict objectForKey:curHwMachine];
    NSLog(@"devInfoArr=%@", devInfoArr);
    NSLog(@"devInfoArr.count=%lu", devInfoArr.count);
    
    NSString *generationStr = Unknown;
    NSString *variantStr = Unknown;
    NSString *aNumberStr = Unknown;

    if (devInfoArr != nil){
        generationStr = devInfoArr[GenerationIndex];
        variantStr = devInfoArr[VariantIndex];
        aNumberStr = devInfoArr[ANumberIndex];
    }

    _generationLbl.text = generationStr;
    _variantLbl.text = variantStr;
    _aNumberLbl.text = aNumberStr;
}

- (IBAction)idfvBtnClicked:(UIButton *)sender {
    NSLog(@"identifierForVendor button clicked");

//    NSString *curDevModel = [[UIDevice currentDevice] identifierForVendor];
    NSUUID *curDevModel = [[UIDevice currentDevice] identifierForVendor];
    NSString *curDevModelStr = [curDevModel UUIDString];
    NSLog(@"curDevModelStr=%@", curDevModelStr);
    _idfvLbl.text = curDevModelStr;
}


- (IBAction)udidBtnClicked:(id)sender {
    NSLog(@"UDID button clicked");
//    NSString *udidNSStr = nil;
    NSString *udidNSStr = @"Fail to get UDID";

    CFTypeRef udidCfStr = MGCopyAnswer(CFSTR("UniqueDeviceID"));
    if (udidCfStr) {
        udidNSStr = [NSString stringWithString: (__bridge NSString * _Nonnull)(udidCfStr)];
        CFRelease(udidCfStr);
    }
    
//    void *gestalt(dlopen("/usr/lib/libMobileGestalt.dylib", RTLDGLOBAL | RTLDLAZY));
//    $MGCopyAnswer = reinterpret_cast(dlsym(gestalt, "MGCopyAnswer"));
//    udidNSStr = (__bridge id)$MGCopyAnswer(CFSTR("UniqueDeviceID"));

//    // NOTE: Can't link to dylib as it doesn't exist in older iOS versions.
//    void *handle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY);
//    if (handle != NULL) {
//        CFPropertyListRef (*MGCopyAnswer)(CFStringRef) = (CFPropertyListRef (*)(CFStringRef))dlsym(handle, "MGCopyAnswer");
//        if (MGCopyAnswer != NULL) {
//            udidNSStr = (__bridge NSString *)(MGCopyAnswer(CFSTR("UniqueDeviceID")));
//        }
//        dlclose(handle);
//    }

    _udidLbl.text = udidNSStr;
}

@end
