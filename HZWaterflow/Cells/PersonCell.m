//
//  MyClosetCell.m
//  MyShow
//
//  Created by Hilen on 8/31/13.
//

#import "PersonCell.h"

@implementation PersonCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth{
    /*
     在这里实现动态高度的计算;
     You can calculate the cell's height here;
     */
    return 90;
}

@end
