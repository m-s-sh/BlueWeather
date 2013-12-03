//
//  WeatherController.h
//  BlueWeather
//
//  Created by Mihail Stefanov on 11/30/13.
//  Copyright (c) 2013 Mommosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherController : NSObject {
    IBOutlet NSOutlineView *_leftView;
    IBOutlet NSTextField *_textField;
    NSMutableArray *_periphralItems;
}
@end
