//
//  BUPrefAgeSeekCell.m
//  TheBureau
//
//  Created by Manjunath on 07/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUPrefAgeSeekCell.h"


@implementation BUPrefAgeSeekCell

- (void)awakeFromNib {
    // Initialization code

//    self.leftLabel.layer.cornerRadius = self.leftLabel.frame.size.width/2.0;
//    self.rightLabel.layer.cornerRadius = self.rightLabel.frame.size.width/2.0;
    
    self.leftView.layer.cornerRadius = self.leftView.frame.size.width/2.0;
    self.rightView.layer.cornerRadius = self.rightView.frame.size.width/2.0;
    
    self.heightSlider.delegate = self;
    self.areaSlider.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    self.prevLocation = [touch locationInView:self.overLayView];
    if(CGRectContainsPoint(self.leftView.frame, self.prevLocation))
    {
        if(1 == self.cellType)
        {
            self.shouldMoveRightView = NO;
            self.shouldMoveLeftView = NO;
        }
        else{
            self.shouldMoveLeftView = YES;
            self.shouldMoveRightView = NO;
        }
    }
    else if(CGRectContainsPoint(self.rightView.frame, self.prevLocation))
    {
        self.shouldMoveLeftView = NO;
        self.shouldMoveRightView = YES;
    }
    else
    {
        self.shouldMoveRightView = NO;
        self.shouldMoveLeftView = NO;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    self.currentLocation = [touch locationInView:self.overLayView];
    
    CGFloat newX = self.currentLocation.x - self.prevLocation.x;
    
    if(self.shouldMoveLeftView)
    {
        CGRect frame = self.leftView.frame;
        frame.origin.x = frame.origin.x + newX;
        if(0 <= frame.origin.x && self.overLayView.frame.size.width >= (frame.origin.x + frame.size.width))
        {
//            NSLog(@"%0.0f is equal to %0.0f",self.currentLocation.x + (2 * self.interval),self.rightView.frame.origin.x);
            
            
            if(self.currentLocation.x + (2 * self.interval) < self.rightView.frame.origin.x)
            {
                self.leftView.frame = frame;
                self.leftViewLeftConstraint.constant += newX;
                self.minLabelLeftConstraint.constant += newX;
                
                if(2 == self.cellType)
                {
                    CGFloat offset = (self.leftViewLeftConstraint.constant / self.interval)+1;
                    NSInteger feet =  4 + (NSInteger)offset / 12;
                    NSInteger inch =  (NSInteger)offset % 12 - 1;
                    inch = inch < 0 ? 0 : inch;
                    self.minFeet = feet;
                    self.minInch = inch;
                    self.minValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
                }
                else if(0 == self.cellType)
                {
                    self.minValueLabel.text = [NSString stringWithFormat:@"%0.0f",(self.leftViewLeftConstraint.constant / self.interval)+18];
                }
                
            }
        }
    }
    else if(self.shouldMoveRightView)
    {
        CGRect frame = self.rightView.frame;
        frame.origin.x = frame.origin.x + newX;
        if(0 <= frame.origin.x && self.overLayView.frame.size.width >= (frame.origin.x + frame.size.width))
        {
//            NSLog(@"%0.0f is equal to %0.0f",self.currentLocation.x - (2 * self.interval),(self.leftView.frame.origin.x + self.leftView.frame.size.width));

            if(self.currentLocation.x - (2 * self.interval) > (self.leftView.frame.origin.x + self.leftView.frame.size.width)) {
                
                self.rightView.frame = frame;
                self.rightViewRightConstraint.constant -= newX;
                self.maxLabelRightConstraint.constant -= newX;
                if(2 == self.cellType)
                {
                    CGFloat offset = (((self.overLayView.frame.size.width - self.rightViewRightConstraint.constant) / self.interval)+1);
                    NSInteger feet =  4 + (NSInteger)offset / 12;
                    NSInteger inch =  (NSInteger)offset % 12 - 1;
                    inch = inch < 0 ? 0 : inch;
                    self.maxFeet = feet;
                    self.maxInch = inch;
                    self.maxValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
                    
                    [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld",(long)self.minFeet] forKey:@"height_from_feet"];
                    [self.preferenceDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.minInch] forKey:@"height_from_inch"];
                    [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld",(long)self.maxFeet] forKey:@"height_to_feet"];
                    [self.preferenceDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.maxInch] forKey:@"height_to_inch"];
                    
                    
                }
                else if(1 == self.cellType)
                {
                    NSInteger currentValue = (((self.overLayView.frame.size.width - self.rightViewRightConstraint.constant) / self.interval)) * 25;
                    
                    currentValue = currentValue - (currentValue % 25) ;
                    NSLog(@"Radius ====> %ld",(long)currentValue);
                    
                    self.maxValueLabel.text = [NSString stringWithFormat:@"%ld",(long)currentValue];
                }
                else
                {
                    self.maxValueLabel.text = [NSString stringWithFormat:@"%0.0f",((self.overLayView.frame.size.width - self.rightViewRightConstraint.constant) / self.interval)+18];
                }
            }
        }
    }
    
    self.prevLocation = self.currentLocation;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    if(2 == self.cellType)
    {
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld",(long)self.minFeet] forKey:@"height_from_feet"];
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.minInch] forKey:@"height_from_inch"];
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld",(long)self.maxFeet] forKey:@"height_to_feet"];
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.maxInch] forKey:@"height_to_inch"];
    }
    else if(0 == self.cellType)
    {
        [self.preferenceDict setValue:self.minValueLabel.text forKey:@"age_from"];
        [self.preferenceDict setValue:self.maxValueLabel.text forKey:@"age_to"];
    }
    else
    {
        [self.preferenceDict setValue:self.maxValueLabel.text forKey:@"location_radius"];
    }
}

- (void)minValueChanged:(float)minValue
{
    if(2 == self.cellType)
    {
        NSInteger feet =  4 + (int)minValue / 12;
        NSInteger inch =  (int)minValue % 12 - 1;
        inch = inch < 0 ? 0 : inch;
        self.minFeet = feet;
        self.minInch = inch;
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld",(long)self.minFeet] forKey:@"height_from_feet"];
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.minInch] forKey:@"height_from_inch"];
        
        
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%ld",(long)self.minFeet] forKey:@"height_from_feet"];
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.minInch] forKey:@"height_from_inch"];
        
        //self.minValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
        NSLog(@"%@",[NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch]);
    }
    else if(0 == self.cellType)
    {
        NSLog(@"%ld", lroundf(minValue));
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld", lroundf(minValue)] forKey:@"age_from"];
        
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%ld",lroundf(minValue)] forKey:@"age_from"];
        
    }
    else
    {
        
    }
}

- (void)maxValueChanged:(float)maxValue
{
    if(2 == self.cellType)
    {
        NSInteger feet =  4 + (NSInteger)maxValue / 13;
        NSInteger inch =  (NSInteger)maxValue % 13 - 1;
        inch = inch < 0 ? 0 : inch;
        self.maxFeet = feet;
        self.maxInch = inch;
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld",(long)self.maxFeet] forKey:@"height_to_feet"];
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.maxInch] forKey:@"height_to_inch"];
        
        
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%ld",(long)self.maxFeet] forKey:@"height_to_feet"];
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.maxInch] forKey:@"height_to_inch"];
        
        
        //self.maxValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
        NSLog(@"%@",[NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch]);
    }
    else if(0 == self.cellType)
    {
        NSLog(@"%ld", lroundf(maxValue));
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld", lroundf(maxValue)] forKey:@"age_to"];
        
        
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%ld",lroundf(maxValue)] forKey:@"age_to"];
        
    }
    else
    {
        
    }
}

- (void)minIntValueChanged:(int)minIntValue
{
    if(2 == self.cellType)
    {
        
        NSInteger feet =  4 + (minIntValue / 12);
        NSInteger inch =  (minIntValue) % 12;

        
//        NSInteger feet =  4 + (NSInteger)minIntValue / 12;
//        NSInteger inch =  (NSInteger)minIntValue % 12 - 1;
        inch = inch < 0 ? 0 : inch;
        self.minFeet = feet;
        self.minInch = inch;
        //self.minValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
        NSLog(@"%@",[NSString stringWithFormat:@"%ld' %02ld\"",(long)feet,(long)inch]);
        
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld",(long)self.minFeet] forKey:@"height_from_feet"];
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.minInch] forKey:@"height_from_inch"];
        
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%ld",(long)self.minFeet] forKey:@"height_from_feet"];
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.minInch] forKey:@"height_from_inch"];
        
    }
    else if(0 == self.cellType)
    {
        
    }
    else
    {
        

    }
}

- (void)maxIntValueChanged:(int)maxIntValue
{
    if(2 == self.cellType)
    {
        NSInteger feet =  4 + (maxIntValue / 12);
        NSInteger inch =  (maxIntValue) % 12;
        inch = inch < 0 ? 0 : inch;
        self.maxFeet = feet;
        self.maxInch = inch;
        //self.minValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
        NSLog(@"%@",[NSString stringWithFormat:@"%ld' %02ld\"",(long)feet,(long)inch]);
        
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%ld",(long)self.maxFeet] forKey:@"height_to_feet"];
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.maxInch] forKey:@"height_to_inch"];
        
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%ld",(long)self.maxFeet] forKey:@"height_to_feet"];
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%02ld",(long)self.maxInch] forKey:@"height_to_inch"];
        
    }
    else if(0 == self.cellType)
    {
        
    }
    else
    {
        maxIntValue = maxIntValue - (maxIntValue % 25);
        NSLog(@"%d",maxIntValue);
        [self.preferenceDict setValue:[NSString stringWithFormat:@"%d",maxIntValue] forKey:@"location_radius"];
        
        [self.parentVc.profDict setValue:[NSString stringWithFormat:@"%d",maxIntValue] forKey:@"location_radius"];
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self performSelector:@selector(setupInterval) withObject:nil afterDelay:0.5];
}

-(void)setDatasource:(NSMutableDictionary *)inDict
{
    
    self.preferenceDict = inDict;//[inDict objectForKey:@"preferences"] == NULL ? inDict : [[inDict objectForKey:@"preferences"] mutableCopy];
    [self performSelector:@selector(updatePrefValues) withObject:nil afterDelay:0.5];
}


-(void)updatePointersForHeight
{

    NSInteger feet = [[self.preferenceDict valueForKey:@"height_from_feet"] intValue];
    NSInteger inch = [[self.preferenceDict valueForKey:@"height_from_inch"] intValue];
    self.minValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
    
    NSInteger feet1 = [[self.preferenceDict valueForKey:@"height_to_feet"] intValue];
    NSInteger inch1 = [[self.preferenceDict valueForKey:@"height_to_inch"] intValue];
    
    
    CGFloat newX1 = 0.0;
    CGFloat newX = newX1 + self.interval * (((feet - 4) *12 ) + inch);
    
    {
        CGRect frame = self.leftView.frame;
        frame.origin.x = newX;
        if(0 <= frame.origin.x && self.overLayView.frame.size.width >= (frame.origin.x + frame.size.width))
        {
            
            [UIView animateWithDuration:0.6 animations:^{
                self.leftView.frame = frame;
                self.leftViewLeftConstraint.constant = newX;
                self.minLabelLeftConstraint.constant = newX;
            }completion:^(BOOL finished) {
                
//                int toAdd = 0;
//                
//                if (<#condition#>) {
//                    <#statements#>
//                }
                
//                NSLog(@"%f,%f",self.leftViewLeftConstraint.constant, self.interval);
//                
                float offset = (self.leftViewLeftConstraint.constant / self.interval);
//
//                if ((offset > 10)&&(offset < 17)) {
//                    offset = offset + 1;
//                }
//                else if (offset > 17) {
//                    offset = offset + 2;
//                }
//                
//                NSLog(@"%f",offset);
                
//                NSInteger feet =  4 + (maxIntValue / 12);
//                NSInteger inch =  (maxIntValue) % 12;
//                
//                (feet - 4)*12
                
                
                self.heightSlider.curMinVal = lroundf(offset) ;
                
                
//                NSInteger feet =  4 + (int)offset / 12;
//                NSInteger inch =  (int)offset % 12;
//                inch = inch < 0 ? 0 : inch;
                self.minFeet = feet;
                self.minInch = inch;
                self.minValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
            }];
            
            // 92.714286,8.428571
        }
    }
    {
        newX1 = 0.0;
        newX = newX1 + self.interval * (((feet1 - 4) *12 ) + inch1);
        CGRect frame = self.leftView.frame;
        frame.origin.x = newX;
        
//        NSLog(@"%f,%f,%f",self.overLayView.frame.size.width,(frame.origin.x + frame.size.width),frame.origin.x);
//        
//        if(0 <= frame.origin.x && self.overLayView.frame.size.width >= (frame.origin.x + frame.size.width))
//        {
            [UIView animateWithDuration:0.6 animations:^{
                self.rightView.frame = frame;
                self.rightViewRightConstraint.constant = self.overLayView.frame.size.width-newX;
                self.maxLabelRightConstraint.constant = self.overLayView.frame.size.width-newX;
            } completion:^(BOOL finished) {
                
                NSLog(@"%f,%f",(self.overLayView.frame.size.width - self.rightViewRightConstraint.constant), self.interval);
                
                CGFloat offset = (((self.overLayView.frame.size.width - self.rightViewRightConstraint.constant) / self.interval));
                
//                if (offset < 9) {
//                    offset = offset - 2;
//                }
//                else if (offset < 17) {
//                    offset = offset - 1;
//                }
                
                NSLog(@"%f",offset);
                
                self.heightSlider.curMaxVal = lroundf(offset);
                
                
//                NSInteger feet =  4 + (int)offset / 12;
//                NSInteger inch =  (int)offset % 12;
//                inch = inch < 0 ? 0 : inch;
                self.maxFeet = feet1;
                self.maxInch = inch1;
                self.maxValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
            }];

//        }
    }
}

-(void)updatePointersForRadius
{
    NSInteger radius = [[self.preferenceDict valueForKey:@"location_radius"] intValue];
    self.areaSlider.curMaxVal = radius;
    NSLog(@"Radius ====> %ld",(long)radius);
    CGFloat newX =  (radius / 25) * self.interval;
    [UIView animateWithDuration:0.6 animations:^{
        self.rightViewRightConstraint.constant = self.overLayView.frame.size.width-newX;
        self.maxLabelRightConstraint.constant = self.overLayView.frame.size.width-newX;
    }completion:^(BOOL finished) {
        self.maxValueLabel.text = [NSString stringWithFormat:@"%ld",(long)radius];
    }];
}

-(void)updatePointersForAge
{
    
    NSInteger ageFrom = [[self.preferenceDict valueForKey:@"age_from"] intValue]-19;
    
    
    CGFloat newX1 = 0.0;
    CGFloat newX = newX1 + self.interval * ageFrom;

    
    {
        CGRect frame = self.leftView.frame;
        frame.origin.x = newX;
        if(0 <= frame.origin.x && self.overLayView.frame.size.width >= (frame.origin.x + frame.size.width))
        {
            
            [UIView animateWithDuration:0.6 animations:^{
                self.leftView.frame = frame;
                self.leftViewLeftConstraint.constant = newX;
                self.minLabelLeftConstraint.constant = newX;
            }completion:^(BOOL finished) {
                self.minValueLabel.text = [NSString stringWithFormat:@"%0.0f",(self.leftViewLeftConstraint.constant / self.interval)+19];
            }];

            
            
        }
    }
    {
        
        NSInteger ageTo = [[self.preferenceDict valueForKey:@"age_to"] intValue] - 18;
        
        newX1 = 0.0;
        CGFloat newX = newX1 + self.interval * ageTo;

        CGRect frame = self.rightView.frame;
        frame.origin.x = newX;
        if(0 <= frame.origin.x && self.overLayView.frame.size.width >= (frame.origin.x + frame.size.width))
        {
            
            [UIView animateWithDuration:0.6 animations:^{
                self.rightView.frame = frame;
                self.rightViewRightConstraint.constant = self.overLayView.frame.size.width-newX;
                self.maxLabelRightConstraint.constant = self.overLayView.frame.size.width-newX;
            }completion:^(BOOL finished) {
                self.maxValueLabel.text = [NSString stringWithFormat:@"%0.0f",((self.overLayView.frame.size.width - self.rightViewRightConstraint.constant) / self.interval) + 18];
            }];
            
            
        }
    }
    
    self.prevLocation = self.currentLocation;
}


-(void)updatePrefValues
{
    
    if(1 == self.cellType)
    {
        NSInteger Radius = [[self.preferenceDict valueForKey:@"location_radius"] intValue];
        self.maxValueLabel.text = [NSString stringWithFormat:@"%ld",Radius];
        [self performSelector:@selector(updatePointersForRadius) withObject:nil afterDelay:0.0];
    }
    else if(0 == self.cellType)
    {
        NSInteger ageFrom = [[self.preferenceDict valueForKey:@"age_from"] intValue];
        
        self.minValueLabel.text = [NSString stringWithFormat:@"%ld",ageFrom];
        
        NSInteger ageTo = [[self.preferenceDict valueForKey:@"age_to"] intValue];
        self.maxValueLabel.text = [NSString stringWithFormat:@"%ld",ageTo];
        [self performSelector:@selector(updatePointersForAge) withObject:nil afterDelay:0.0];
        self.ageSlider.curMinVal = ageFrom;
        self.ageSlider.curMaxVal = ageTo;
    }
    else
    {
        NSInteger feet = [[self.preferenceDict valueForKey:@"height_from_feet"] intValue];
        NSInteger inch = [[self.preferenceDict valueForKey:@"height_from_inch"] intValue];
        self.minValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet,(long)inch];
    
        self.minFeet = feet;
        self.minInch = inch;

        NSInteger feet1 = [[self.preferenceDict valueForKey:@"height_to_feet"] intValue];
        NSInteger inch1 = [[self.preferenceDict valueForKey:@"height_to_inch"] intValue];
        self.maxFeet = feet1;
        self.maxInch = inch1;
        
        self.maxValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"",(long)feet1,(long)inch1];

        [self performSelector:@selector(updatePointersForHeight) withObject:nil afterDelay:0.0];
    }
}

-(void)setupInterval
{
    
    
    NSLog(@"%f",self.overLayView.frame.size.width);
    
    if(2 == self.cellType)
    {
        self.interval = self.overLayView.frame.size.width / 35.0;
    }
    else if(1 == self.cellType)
    {
        self.interval = self.overLayView.frame.size.width / 12.0;
    }
    else
    {
        self.interval = self.overLayView.frame.size.width / 24.0;
//        [self setminAge:15 maxAge:34];
    }
}



@end
