//
//  UILabel+WMLabel.m
//  label
//
//  Created by zwm on 16/7/27.
//  Copyright © 2016年 zwm. All rights reserved.
//

#import "UILabel+WMLabel.h"
#import <CoreText/CoreText.h>

@implementation UILabel (WMLabel)

- (CGPoint)getLastLineTail
{
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)[self getOptimizedAttributedString]);

    CGRect textRect = [self textRect];
    textRect.size.height += 20;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);

    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);

    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    if (lines.count > 0) {
        CGPoint lineOrigin[1];
        CTFrameGetLineOrigins(frame, CFRangeMake(lines.count-1, 1), lineOrigin);

        // Get bounding information of line
        CTLineRef lineRef = (__bridge CTLineRef)lines[lines.count - 1];
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        width -= CTLineGetTrailingWhitespaceWidth(lineRef);
        CGFloat yMin = lineOrigin[0].y - descent;
        CGFloat yMax = lineOrigin[0].y + ascent;

        CFRelease(frame);
        CFRelease(path);
        return CGPointMake(lineOrigin[0].x + width, textRect.size.height - (yMin + yMax) / 2);
    }

    CFRelease(frame);
    CFRelease(path);
    return CGPointZero;
}

- (CGRect)textRect
{
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;

    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }

    return textRect;
}

- (NSMutableAttributedString *)getOptimizedAttributedString
{
    NSMutableAttributedString *optimizedAttributedText = [self.attributedText mutableCopy];

    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    __weak typeof(self) weakself = self;
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (!attrs[(NSString *)kCTFontAttributeName]) {
            [optimizedAttributedText addAttribute:(NSString *)kCTFontAttributeName value:weakself.font range:NSMakeRange(0, [weakself.attributedText length])];
        }

        if (!attrs[(NSString *)kCTParagraphStyleAttributeName]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:weakself.lineBreakMode];

            [optimizedAttributedText addAttribute:(NSString *)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];

    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString *)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        NSMutableParagraphStyle *paragraphStyle = [value mutableCopy];

        if ([paragraphStyle lineBreakMode] == NSLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        }

        [optimizedAttributedText removeAttribute:(NSString *)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString *)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
    }];

    return optimizedAttributedText;
}

@end
