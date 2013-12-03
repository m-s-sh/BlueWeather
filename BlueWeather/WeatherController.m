//
//  WeatherController.m
//  BlueWeather
//
//  Created by Mihail Stefanov on 11/30/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import "Discovery.h"
#import "WeatherController.h"

@interface WeatherController() <DiscoveryDelegate>
{
    
}

@end

@implementation WeatherController

- (void)awakeFromNib
{
    [[Discovery sharedInstance] setDiscoveryDelegate:self];
    _textField.stringValue = @"0.00";
    _periphralItems = [NSMutableArray new];
}

- (void)reloadData
{
    [_leftView reloadData];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [_leftView expandItem:nil expandChildren:YES];
    [NSAnimationContext endGrouping];
}
#pragma mark -
#pragma mark DiscoveryDelegate
/****************************************************************************/
/*                       DiscoveryDelegate Methods                          */
/****************************************************************************/

- (void) discoveryDidRefresh
{
    [self reloadData];
}

- (void) discoveryStatePoweredOff
{
}

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
        return result;
    } else {
        NSTextField *result = [outlineView makeViewWithIdentifier:@"HEADER_CELL" owner:self];
        result.stringValue = @"DEVICES";
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
    return ![item isKindOfClass:[NSArray class]];
}
@end
