//
//  WeatherController.m
//  BlueWeather
//
//  Created by Mihail Stefanov on 11/30/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import "WeatherController.h"
#import "SensorTag.h"
#import "Discovery.h"

@interface WeatherController() <DiscoveryDelegate, SensorTagDelegate>
{
    BOOL _selfSelection;
}

@end

@implementation WeatherController

- (void)awakeFromNib
{
    [[Discovery sharedInstance] setDiscoveryDelegate:self];
    [[Discovery sharedInstance] setPeripheralDelegate:self];
    _periphralItems = [NSMutableArray new];
}

- (void)reloadData
{
    NSInteger selectedRow = [_leftView selectedRow];
    [_leftView reloadData];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [_leftView expandItem:nil expandChildren:YES];
    if (selectedRow != -1) {
        _selfSelection = YES;
        [_leftView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
        _selfSelection = NO;
    }
    [NSAnimationContext endGrouping];
}

- (IBAction)connectOrDisconnect:(id)sender
{
    NSButton *button = (NSButton *)sender;
    CBPeripheral *peripheral = [(NSTableCellView *)[button superview] objectValue];
    if (peripheral.state == CBPeripheralStateConnected) {
        [[Discovery sharedInstance] disconnectPeripheral:peripheral];
        button.title = @"connect";
    }  else if (peripheral.state == CBPeripheralStateDisconnected) {
        [[Discovery sharedInstance] connectPeripheral:peripheral];
        button.title = @"disconnect";
    }
}

#pragma mark -
#pragma mark DiscoveryDelegate

- (void) discoveryDidRefresh
{
    _ambientTemperatureField.stringValue = @"-.--";
    _IRTemperatureField.stringValue = @"-.--";
    [self reloadData];
}

- (void) discoveryStatePoweredOff
{
}

#pragma mark -
#pragma mark SensorTagDelegate
- (void)sensorTagDidChangeStatus:(SensorTag *)tag
{
    if(tag.peripheral.state == CBPeripheralStateConnected) {
        _ambientTemperatureField.stringValue =
            [NSString stringWithFormat:@"%.1f°C",tag.ambientTemerature];
        _IRTemperatureField.stringValue = [NSString stringWithFormat:@"%.1f°C",tag.IRTemerature];
    }
}

#pragma mark -
#pragma NSOutlineView notifications

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    
}

#pragma mark -
#pragma mark NSOutlineViewDelegate and NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (!item) {
        return 1;
    }
    if ([item isKindOfClass:[NSArray class]]) {
        return ((NSArray*)item).count;
    }
    return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return ([item isKindOfClass:[CBPeripheral class]]) ? NO : YES;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (!item) {
        return [Discovery sharedInstance].foundPeripherals;
    } else {
         return [item objectAtIndex:index];
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if ([item isKindOfClass:[CBPeripheral class]]) {
        NSTableCellView *result = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        result.textField.stringValue = ((CBPeripheral*)item).name;
        NSString *iconName = (((CBPeripheral*)item).state == CBPeripheralStateConnected) ? @"bluetooth_connected" : @"bluetooth_disconnected";
        result.imageView.image = [NSImage imageNamed:iconName];
        result.objectValue = item;
        return result;
    } else {
        NSTableCellView *result = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        result.textField.stringValue = @"DEVICES";
        return result;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    return [item isKindOfClass:[NSArray class]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    return ![item isKindOfClass:[NSArray class]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return NO;
}
@end
