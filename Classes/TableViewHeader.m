//
//  TableViewHeader.m
//  CheckIn
//
//  Created by wolfert on 11/1/12.
//
//

#import "TableViewHeader.h"

@implementation TableViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lunatech Research logo.png"]];
        logo.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-10);
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:logo];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
