//
//  UICustomButton.m
//
//  Updated by Oskari Rauta. Based on original code by Chris Jones.
//
//  Copyright 2011 Chris Jones. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UICustomButton.h"
#import <QuartzCore/QuartzCore.h>

#define kButtonRadius 6.0

@implementation UICustomButton
@synthesize selected = _selected;
@synthesize toggled=_toggled;
@synthesize pause = _pause;
@synthesize invocation = _invocation;
@synthesize hue = _hue;
@synthesize saturation = _saturation;
@synthesize brightness = _brightness;
@synthesize buttonStyle = _buttonStyle;
@synthesize label=_label;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		CGFloat alpha;
		[self setOpaque: NO];
		[self setBackgroundColor: [UIColor clearColor]];
		
		if ( ![[self backgroundColor] getHue:&_hue saturation:&_saturation brightness:&_brightness alpha:&alpha] ) {
			_hue = 1.0;
			_saturation = 1.0;
			_brightness = 1.0;
		}
		
		[self setBackgroundColor: [UIColor clearColor]];
    }
    return self;
}


- (id)initWithTextAndHSB:(NSString *)text target:(id)target selector:(SEL)selector hue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
	
	_hue=hue;
	_saturation=saturation;
	_brightness=brightness;
	
    if ((self = [super initWithFrame:CGRectZero])) {
        
        // Create invocation to be called upon a tap
        if (target && selector) {
            NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:selector];
            if (signature != nil) {
                self.invocation = [NSInvocation invocationWithMethodSignature:signature];
                [_invocation setTarget:target];
                [_invocation setSelector:selector];
                [_invocation setArgument:&self atIndex:2];
            }
        }
        if ( [text isEqualToString: @"X"] ) {
			UIImage	*image = [UIImage imageNamed:@"backspace.png"];
			UIImageView	*imageView = [[UIImageView alloc] initWithFrame:CGRectMake (20,10,40,32)];
			
			//add a shadow to the image to make it look "inset" into the button
			CALayer * shadowLayer = [imageView layer];
			shadowLayer.masksToBounds = NO;
			shadowLayer.shadowOffset = CGSizeMake(0,-1);
			shadowLayer.shadowOpacity = 0.7f;
			shadowLayer.shadowRadius = 0.5;
			
			[imageView setImage:image];
			[self addSubview:imageView];
		} else if ([text isEqual:@"Tab"]) {
			
			UIImage	*image = [UIImage imageNamed:@"tab2.png"];
			UIImageView	*imageView = [[UIImageView alloc] initWithFrame:CGRectMake (20,10,40,32)];
			
			//add a shadow to the image to make it look "inset" into the button
			CALayer * shadowLayer = [imageView layer];
			shadowLayer.masksToBounds = NO;
			shadowLayer.shadowOffset = CGSizeMake(0,-1);
			shadowLayer.shadowOpacity = 0.7f;
			shadowLayer.shadowRadius = 0.5;
			
			[imageView setImage:image];
			[self addSubview:imageView];
			_pause = YES;
		} else {
            // Create label for button
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textAlignment = NSTextAlignmentCenter;
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            label.text = text;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
			
			label.font = [UIFont boldSystemFontOfSize:24];
			
			CALayer * shadowLayer = [label layer];
			shadowLayer.masksToBounds = NO;
			shadowLayer.shadowOffset = CGSizeMake(0,-1);
			shadowLayer.shadowOpacity = 0.7f;
			shadowLayer.shadowRadius = 0.5;
			
            [self addSubview:label];
            _label = label;
        }
		
    }
    return self;
}

- (void)setLabelWithText:(NSString*)text andSize:(float)size andVerticalShift:(float)shift {
	// Create label for button
	CGRect frame=CGRectMake(self.bounds.origin.x, self.bounds.origin.y+shift, self.bounds.size.width, self.bounds.size.height);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.textAlignment = NSTextAlignmentCenter;
	label.text = text;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	
	label.font = [UIFont boldSystemFontOfSize:size];
	
	CALayer * shadowLayer = [label layer];
	shadowLayer.masksToBounds = NO;
	shadowLayer.shadowOffset = CGSizeMake(0,-1);
	shadowLayer.shadowOpacity = 0.7f;
	shadowLayer.shadowRadius = 0.5;
	
	[self addSubview:label];
	_label = label;
}

- (id)initWithText:(NSString *)text target:(id)target selector:(SEL)selector
{
	return [self initWithTextAndHSB:text target:target selector:selector hue:0.0f saturation:0.0f brightness:0.0f];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGFloat actualBrightness = _brightness;
    if (self.selected) {
        actualBrightness -= 0.10;
    }
    
    CGColorRef blackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    CGColorRef highlightStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7].CGColor;
    CGColorRef highlightStop = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0].CGColor;
	
	CGColorRef outerTop = [UIColor colorWithHue:_hue saturation:_saturation brightness:1.0*actualBrightness alpha:1.0].CGColor;
    CGColorRef outerBottom = [UIColor colorWithHue:_hue saturation:_saturation brightness:0.80*actualBrightness alpha:1.0].CGColor;
	
    CGFloat outerMargin = 7.5f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
    CGMutablePathRef outerPath = [self createRoundedRectForRect:outerRect withRadius:6.0];

    // Draw gradient for outer path
	CGContextSaveGState(context);
	CGContextAddPath(context, outerPath);
	CGContextClip(context);
	[self drawLinearGradientInRect:outerRect withStartingColor:outerTop withEndingColor:outerBottom];
	
	CGContextRestoreGState(context);
	
	if (!self.selected) {
		
		CGRect highlightRect = CGRectInset(outerRect, 1.0f, 1.0f);
		CGMutablePathRef highlightPath = [self createRoundedRectForRect:highlightRect withRadius:6.0];
		
		CGContextSaveGState(context);
		CGContextAddPath(context, outerPath);
		CGContextAddPath(context, highlightPath);
		CGContextEOClip(context);
		
		[self drawLinearGradientInRect:CGRectMake(outerRect.origin.x, outerRect.origin.y, outerRect.size.width, outerRect.size.height/3) withStartingColor:highlightStart withEndingColor:highlightStop];
		CGContextRestoreGState(context);
		
		[self drawCurverGlossInRect:outerRect withRadius:180];
		CFRelease(highlightPath);
		
	}
	else {
		//reverse non-curved gradient when pressed
		CGContextSaveGState(context);
		CGContextAddPath(context, outerPath);
		CGContextClip(context);
		[self drawLinearGlossInRect: outerRect Reversed: YES];
		CGContextRestoreGState(context);
		
	}
	if (!self.toggled) {
		//bottom highlight
		CGRect highlightRect2 = CGRectInset(self.bounds, 6.5f, 6.5f);
		CGMutablePathRef highlightPath2 = [self createRoundedRectForRect:highlightRect2 withRadius:6.0];
		
		CGContextSaveGState(context);
		CGContextSetLineWidth(context, 0.5);
		CGContextAddPath(context, highlightPath2);
		CGContextAddPath(context, outerPath);
		CGContextEOClip(context);
		[self drawLinearGradientInRect:CGRectMake(self.bounds.origin.x, self.bounds.size.height-self.bounds.size.height/3, self.bounds.size.width, self.bounds.size.height/3) withStartingColor:highlightStop withEndingColor:highlightStart ];
		
		CGContextRestoreGState(context);
		CFRelease(highlightPath2);
	}
    else {
		//toggle marker
		CGRect toggleRect= CGRectInset(self.bounds, 5.0f, 5.0f);
		CGMutablePathRef togglePath= [self createRoundedRectForRect:toggleRect withRadius:8.0];
		
		CGContextSaveGState(context);
		CGContextSetLineWidth(context, 3.5);
		CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
		CGContextAddPath(context, togglePath);
		CGContextStrokePath(context);
		CGContextRestoreGState(context);
		CFRelease(togglePath);
	}
    // Stroke outer path
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, blackColor);
    CGContextAddPath(context, outerPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
	
    CFRelease(outerPath);
	
    
}

-(BOOL)toggled {
	return _toggled;
}

-(void) setToggled:(BOOL)toggled {
    if (_toggled == toggled) return;
    _toggled = toggled;
    [self setNeedsDisplay];
}

-(BOOL)selected {
	return _selected;
}

-(void) setSelected:(BOOL)selected {
    if (_selected == selected) return;
    _selected = selected;
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = YES;
    if (_invocation != nil) {
        if (!_pause) [_invocation invoke];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = NO;
	if (_pause) [_invocation invoke];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = NO;
}

-(void) drawLinearGradientInRect:(CGRect)rect withStartingColor:(CGColorRef)startColor withEndingColor:(CGColorRef)endColor
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

-(void)drawLinearGlossInRect:(CGRect)rect Reversed:(BOOL)reverse
{
	CGColorRef highlightStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor;
	CGColorRef highlightEnd = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
	
    if (reverse) {
		
		CGRect half = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height/2, rect.size.width, rect.size.height/2);
		[self drawLinearGradientInRect:half withStartingColor:highlightEnd withEndingColor:highlightStart];
	}
	else {
		CGRect half = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
		[self drawLinearGradientInRect:half withStartingColor:highlightStart withEndingColor:highlightEnd];
	}
    
}

-(void)drawCurverGlossInRect:(CGRect)rect withRadius:(CGFloat)radius
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGColorRef glossStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6].CGColor;
	CGColorRef glossEnd = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
		
	CGMutablePathRef glossPath = CGPathCreateMutable();
	
	CGContextSaveGState(context);
    CGPathMoveToPoint(glossPath, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect)-radius+rect.size.height/2);
	CGPathAddArc(glossPath, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect)-radius+rect.size.height/2, radius, 0.75f*M_PI, 0.25f*M_PI, YES);
	CGPathCloseSubpath(glossPath);
	CGContextAddPath(context, glossPath);
	CGContextClip(context);
	
	CGMutablePathRef buttonPath = [self createRoundedRectForRect:rect withRadius:6.0];
	
	CGContextAddPath(context, buttonPath);
	CGContextClip(context);
	
	CGRect half = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
	
	[self drawLinearGradientInRect:half withStartingColor:glossStart withEndingColor:glossEnd];
	CGContextRestoreGState(context);
    
	CGPathRelease(buttonPath);
	CGPathRelease(glossPath);
}

-(CGMutablePathRef)createRoundedRectForRect:(CGRect)rect withRadius:(CGFloat)radius
{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    return path;
}

-(CGMutablePathRef)createRoundedRectForRectCCW:(CGRect)rect withRadius:(CGFloat)radius
{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    return path;
}

@end
