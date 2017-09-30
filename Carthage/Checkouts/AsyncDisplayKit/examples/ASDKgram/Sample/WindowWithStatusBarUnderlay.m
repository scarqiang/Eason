//
//  WindowWithStatusBarUnderlay.m
//  Sample
//
//  Created by Hannah Troisi on 4/10/16.
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "WindowWithStatusBarUnderlay.h"
#import "Utilities.h"

@implementation WindowWithStatusBarUnderlay
{
  UIView *_statusBarOpaqueUnderlayView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _statusBarOpaqueUnderlayView                 = [[UIView alloc] init];
    _statusBarOpaqueUnderlayView.backgroundColor = [UIColor darkBlueColor];
    [self addSubview:_statusBarOpaqueUnderlayView];
  }
  return self;
}

-(void)layoutSubviews
{
  [super layoutSubviews];
  
  [self bringSubviewToFront:_statusBarOpaqueUnderlayView];
  
  CGRect statusBarFrame              = CGRectZero;
  statusBarFrame.size.width          = [[UIScreen mainScreen] bounds].size.width;
  statusBarFrame.size.height         = [[UIApplication sharedApplication] statusBarFrame].size.height;
  _statusBarOpaqueUnderlayView.frame = statusBarFrame;
}

@end
