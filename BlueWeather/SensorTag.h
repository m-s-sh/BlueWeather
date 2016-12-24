//
//  SensorTag.h
//  BlueWeather
//
//  Created by Mihail Stefanov on 12/23/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class SensorTag;
@protocol SensorTagDelegate<NSObject>
- (void) sensorTagDidChangeStatus:(SensorTag*)tag;
@end

@interface SensorTag : NSObject

@property (nonatomic, readonly) float ambientTemerature;
@property (nonatomic, readonly) float IRTemerature;
@property (nonatomic, assign, readonly) id<SensorTagDelegate> delegate;
@property (nonatomic, readonly)   CBPeripheral *peripheral;

- (id)initWithPeripheral:(CBPeripheral *)peripheral controller:(id<SensorTagDelegate>)controller;
- (void)start;

@end
