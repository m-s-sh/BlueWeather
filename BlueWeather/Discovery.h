//
//  Discovery.h
//  BlueWeather
//
//  Created by Mihail Stefanov on 11/4/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>


/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol DiscoveryDelegate <NSObject>
- (void) discoveryDidRefresh;
- (void) discoveryStatePoweredOff;
@end

@interface Discovery : NSObject

+ (Discovery*) sharedInstance;

@property (nonatomic, assign) id<DiscoveryDelegate>   discoveryDelegate;
/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;

/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (readonly, nonatomic) NSMutableArray    *foundPeripherals;
@end
