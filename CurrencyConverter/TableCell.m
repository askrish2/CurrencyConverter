//
//  TableCell.m
//  CurrencyConverter
//
//  Created by Ashwini Krishnan on 9/6/16.
//  Copyright © 2016 Ash Krishnan. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

- (void)prepareForReuse {
    [super prepareForReuse];
    for(UIView *subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }
}

- (void) setTags:(NSString *)tags {
    
    NSLog(@"TAGS: %@", _tags);

    _tags = tags;
    
    //[self.label setCenter:self.view.center];
    
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.bounds.size.width-25, self.bounds.size.height)];
    }
    NSLog(@"here");
    
    [_label setText:@""];
    [_label setClearsContextBeforeDrawing:YES];
    [_label clearsContextBeforeDrawing];
    
    [_label setText:_tags];
    [_label setTextColor:[UIColor whiteColor]];
    NSLog(@"TAGS: %@", _tags);
    
    [self addSubview:_label];
    
    //return self;
}

@end
