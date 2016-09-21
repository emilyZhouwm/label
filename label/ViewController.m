//
//  ViewController.m
//  label
//
//  Created by zwm on 16/7/27.
//  Copyright © 2016年 zwm. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+WMLabel.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *leftLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textChange
{
    _leftLbl.text = _textField.text;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2;
    NSDictionary *attributes = @{NSFontAttributeName:_leftLbl.font, NSParagraphStyleAttributeName:paragraphStyle};
    _leftLbl.attributedText = [[NSAttributedString alloc] initWithString:_leftLbl.text attributes:attributes];
    [_leftLbl setNeedsLayout];
    [_leftLbl layoutIfNeeded];
    CGPoint tail = [_leftLbl getLastLineTail];
    if (CGRectGetWidth(_rightLbl.frame) + tail.x > CGRectGetWidth(self.view.frame) - 40) {
        _bottomLayout.constant = 21;
    } else {
        _bottomLayout.constant = 0;
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *str = textField.text;
//    // Handling 'delete'
//    if (range.length == 1 && [string isEqualToString:@""]) {
//        _leftLbl.text = [str substringToIndex:([str length] - 1)];
//    } else {
//        _leftLbl.text = [str stringByAppendingString:string];
//    }
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineHeightMultiple = 1.2;
//    NSDictionary *attributes = @{NSFontAttributeName:_leftLbl.font, NSParagraphStyleAttributeName:paragraphStyle};
//    _leftLbl.attributedText = [[NSAttributedString alloc] initWithString:_leftLbl.text attributes:attributes];
//    [_leftLbl setNeedsLayout];
//    [_leftLbl layoutIfNeeded];
//
//    CGPoint tail = [_leftLbl getLastLineTail];
//    if (CGRectGetWidth(_rightLbl.frame) + tail.x > CGRectGetWidth(self.view.frame) - 40) {
//        _bottomLayout.constant = 21;
//    } else {
//        _bottomLayout.constant = 0;
//    }
//
//    return TRUE;
//}

@end
