//
//  SensorService.m
//  BlueWeather
//
//  Created by Mihail Stefanov on 12/1/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import "SensorService.h"

@interface SensorService() <CBPeripheralDelegate>

@end

@implementation SensorService

- (id) initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        _peripheral.delegate = self;
    }
    return self;
}

@end
