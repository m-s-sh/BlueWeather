//
//  Sensors.h
//  BlueWeather
//
//  Created by Mihail Stefanov on 12/23/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sensorTMP006 : NSObject

+(float) calcTAmb:(NSData *)data;
+(float) calcTAmb:(NSData *)data offset:(int)offset;
+(float) calcTObj:(NSData *)data;


@end
