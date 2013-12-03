//
//  SensorService.h
//  BlueWeather
//
//  Created by Mihail Stefanov on 12/1/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

@interface SensorService : NSObject
{
    CBPeripheral *_peripheral;
}

- (id) initWithPeripheral:(CBPeripheral *)peripheral;
@end
