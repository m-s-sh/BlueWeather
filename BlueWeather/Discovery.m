//
//  Discovery.m
//  BlueWeather
//
//  Created by Mihail Stefanov on 11/4/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//


#import "Discovery.h"

extern NSString *kTemperatureSensorServiceUUIDString;

@interface Discovery() <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager    *_centralManager;
    BOOL _pendingInit;
}
@end

@implementation Discovery

+ (Discovery*) sharedInstance
{
	static Discovery *this = nil;
    
	if (!this)
		this = [[Discovery alloc] init];
    
    return this;
}

- (id) init
{
    self = [super init];
    if (self) {
        _pendingInit = YES;
		_centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        _foundPeripherals = [[NSMutableArray alloc] init];
        _connectedPeripherals = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startScanningForUUIDString:(NSString *)uuidString
{
    [_centralManager scanForPeripheralsWithServices:
     [NSArray arrayWithObjects:kTemperatureSensorServiceUUIDString, nil] options:nil];
}

- (void)stopScanning
{
    
}

#pragma mark -
#pragma mark Connection/Disconnection

- (void) connectPeripheral:(CBPeripheral*)peripheral
{
	if (peripheral.state == CBPeripheralStateDisconnected) {
		[_centralManager connectPeripheral:peripheral options:nil];
	}
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
	[_centralManager cancelPeripheralConnection:peripheral];
}

#pragma mark -
#pragma mark CBCentralManagerDelegate

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
 	SensorTag    *tag	= nil;
  
	// Create a service instance.
	tag = [[SensorTag alloc] initWithPeripheral:peripheral controller:_peripheralDelegate];
    [tag start];
    
	if (![_connectedPeripherals containsObject:tag])
		[_connectedPeripherals addObject:tag];
    
    [_peripheralDelegate sensorTagDidChangeStatus:tag];
    [_discoveryDelegate discoveryDidRefresh];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    for (SensorTag *tag in _connectedPeripherals) {
        if (tag.peripheral == peripheral) {
            [_connectedPeripherals removeObject:tag];
            [_discoveryDelegate discoveryDidRefresh];
            return;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered peripheral with name %@\n", peripheral.name);
    if (![_foundPeripherals containsObject:peripheral]) {
		[_foundPeripherals addObject:peripheral];
		[_discoveryDelegate discoveryDidRefresh];
	}
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch ([_centralManager state]) {
        case CBCentralManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
			break;
		}

        case CBCentralManagerStatePoweredOn:
        {
			_pendingInit = NO;
            [self   startScanningForUUIDString:nil];
            [_discoveryDelegate discoveryDidRefresh];
            break;
        }
        
        case CBCentralManagerStatePoweredOff:
		{
            break;
        }
        
        case CBCentralManagerStateResetting:
		{
            _pendingInit = YES;
			break;
		}
            
        case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			break;
		}
        
        case CBCentralManagerStateUnsupported:
        {
            
        }
    }
}
@end
