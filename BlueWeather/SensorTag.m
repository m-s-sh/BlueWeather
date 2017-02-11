//
//  SensorTag.m
//  BlueWeather
//
//  Created by Mihail Stefanov on 12/23/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import "Sensors.h"
#import "SensorTag.h"

NSString *kTemperatureSensorServiceUUIDString =     @"F000AA00-0451-4000-B000-000000000000";
NSString *kTemperatureSensorDataUUIDString =        @"F000AA01-0451-4000-B000-000000000000";
NSString *kTemperatureSensorDataConfigUUIDString =  @"F000AA02-0451-4000-B000-000000000000";

@interface SensorTag() <CBPeripheralDelegate> {
    CBService *_temperatureService;
    CBCharacteristic *_temperatureCharacteristic;
}

@end

@implementation SensorTag

- (id)initWithPeripheral:(CBPeripheral *)peripheral controller:(id<SensorTagDelegate>)controller
{
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        _delegate = controller;
    }
    return self;
}

- (void)start
{
	CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kTemperatureSensorServiceUUIDString];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    
    [_peripheral discoverServices:serviceArray];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSArray		*services	= nil;
	
	if (peripheral != _peripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
		return ;
	}
    
	services = [peripheral services];
	if (!services || ![services count]) {
		return ;
	}
    
	_temperatureService = nil;
    
	for (CBService *service in services) {
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:kTemperatureSensorServiceUUIDString]]) {
			_temperatureService = service;
			break;
		}
	}
    
	if (_temperatureService) {
		[peripheral discoverCharacteristics:nil forService:_temperatureService];
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    
}
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
	NSArray		*characteristics	= [service characteristics];
	CBCharacteristic *characteristic;
    
	if (peripheral != _peripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
	
	if (service != _temperatureService) {
		NSLog(@"Wrong Service.\n");
		return ;
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
	for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        
		if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kTemperatureSensorDataConfigUUIDString]]) {
            uint8_t data = 0x01;
			[_peripheral writeValue:[NSData dataWithBytes:&data length:1] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        } else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kTemperatureSensorDataUUIDString]]) {
            _temperatureCharacteristic = characteristic;
            [_peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }

	}
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([characteristic.UUID isEqual:_temperatureCharacteristic.UUID]) {
        NSLog(@"[didUpdateValueForCharacteristic]%@",characteristic.value);
        _ambientTemerature = [sensorTMP006 calcTAmb:characteristic.value];
        _IRTemerature = [sensorTMP006 calcTObj:characteristic.value];
        [_delegate sensorTagDidChangeStatus:self];
    }
}
@end
