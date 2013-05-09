//
//  GlossButtonViewController.h
//  GlossButton
//
//  Created by Chris Jones on 10/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomButton.h"

@interface GlossButtonViewController : UIViewController {

	UICustomButton *_button1, *_button2, *_button3, *_button4, *_button5;
	UICustomButton *_button6, *_button7, *_button8, *_button9, *_button0;
	UICustomButton *_buttonPoint, *_buttonPlus, *_buttonMinus, *_buttonDivide;
	UICustomButton *_buttonMultiply, *_buttonClear, *_buttonEquals, *_buttonPlusminus;
	
	NSMutableArray *_buttons;

}

@property (retain) UICustomButton *button1;
@property (retain) UICustomButton *button2;
@property (retain) UICustomButton *button3;
@property (retain) UICustomButton *button4;
@property (retain) UICustomButton *button5;
@property (retain) UICustomButton *button6;
@property (retain) UICustomButton *button7;
@property (retain) UICustomButton *button8;
@property (retain) UICustomButton *button9;
@property (retain) UICustomButton *button0;
@property (retain) UICustomButton *buttonPoint;

@property (retain) UICustomButton *buttonPlus;
@property (retain) UICustomButton *buttonMinus;
@property (retain) UICustomButton *buttonDivide;
@property (retain) UICustomButton *buttonMultiply;
@property (retain) UICustomButton *buttonEquals;
@property (retain) UICustomButton *buttonClear;
@property (retain) UICustomButton *buttonPlusminus;

@property (retain) NSMutableArray *buttons;
@end

