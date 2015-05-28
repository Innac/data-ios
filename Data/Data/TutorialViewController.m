//
//  TutorialViewController.m
//  Data
//
//  Created by kevin Budain on 26/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "TutorialViewController.h"
#import "BaseViewController.h"

@interface TutorialViewController ()

@end

BaseViewController *baseView;
DataView *dataView;

UISwipeGestureRecognizer *leftGesture;
UITapGestureRecognizer *closeAllInformationDataGesture;

int translation, indexTutorial, dataCount;
float duration;
NSMutableArray *titleArray, *subTitleTutorial;
CGFloat dataViewHeight;

NSDictionary *dictionnary;

@implementation TutorialViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    translation = 20;
    duration = 0.5;
    indexTutorial = 0;

    titleArray = [@[@"Hours 1/4", @"Captation 2/4", @"Hours data 3/4", @"Daily data 4/4"] mutableCopy ];
    subTitleTutorial = [@[@"chaque point correspond\nà une heure de la journée", @"le point centrale t’indique\nque l’application capte des ddonnées", @"TAPE SUR UNE HEURE POUR\nVOIR LES DONNÉES RÉCOLTÉES", @"TAPE SUR UNE HEURE POUR\nVOIR LES DONNÉES RÉCOLTÉES"] mutableCopy ];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    dataViewHeight = self.view.bounds.size.height * 0.30;

    UIView *contentView = [[UIView alloc] init];
    [contentView setFrame:CGRectMake(0, dataViewHeight, self.view.bounds.size.width, self.view.bounds.size.height * 0.70)];
    [contentView setBackgroundColor:[baseView colorWithRGB:243 :243 :243 :1]];
    [self.view addSubview:contentView];

    dataView = [[DataView alloc] init];
    [dataView setFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)];
    [dataView initView:self];
    dataView.informationButton = NO;
    [contentView addSubview:dataView];

    [self updateLabel];

    [self.hourLabel setText:@"toto"];
    [self.verticalLabelConstraint setConstant:(self.view.bounds.size.height * 0.60)];
    [self.view addSubview:self.hourLabel];

    NSString *pathJson = [[NSBundle mainBundle] pathForResource:@"tutorialExperience" ofType:@"json"];

    if([[NSFileManager defaultManager] fileExistsAtPath:pathJson]){

        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:pathJson encoding:NSUTF8StringEncoding error:nil];
        NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        self.parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

        dictionnary = self.parsedData[@"day"];

    }

    /** hide **/
    [self animatedView:self.hourLabel Duration:0 Delay:0 Alpha:0 TranslationX:-translation TranslationY:0];
    [self animatedView:self.tutorialLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

    /** show **/
    [self animatedView:self.tutorialLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.informationLabel Duration:duration Delay:duration+0.1 Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.hourLabel Duration:duration Delay:duration * 2 Alpha:1 TranslationX:0 TranslationY:0];

    /** gesture **/
    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftGesture];

    closeAllInformationDataGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAllInformationData:)];

    self.informationDataGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(informationData:)];

    self.closeInformationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeInformationData:)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateLabel {

    [self.tutorialLabel setText:[[titleArray objectAtIndex:indexTutorial] uppercaseString]];
    [self.informationLabel setText:[[subTitleTutorial objectAtIndex:indexTutorial] uppercaseString]];
    [baseView addLineHeight:1.3 Label:self.informationLabel];

}

/** swipe gesture **/
- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {

    indexTutorial++;
    if(indexTutorial == 1) {

        [self animatedView:self.hourLabel Duration:duration Delay:0 Alpha:0 TranslationX:-translation TranslationY:0];

        for (CAShapeLayer *layer in dataView.layer.sublayers) {

            if ([layer isKindOfClass:[CAShapeLayer class]]) {

                CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                [opacityAnimation setFromValue: [NSNumber numberWithFloat:1]];
                [opacityAnimation setToValue: [NSNumber numberWithFloat:0]];
                [opacityAnimation setDuration: duration];
                [opacityAnimation setFillMode:kCAFillModeForwards];
                [opacityAnimation setRemovedOnCompletion:NO];

                [layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
                
            }

        }
        self.tutorialDay = [[Day alloc] initWithDictionary:dictionnary error:nil];
        dataCount = (int)[self.tutorialDay.data count];
        for (int i = 0; i < dataCount; i++) {
            [dataView generateData:i Day:self.tutorialDay];
        }
        [dataView updateAllInformation];
        [dataView performSelector:@selector(activeCapta) withObject:nil afterDelay:3];

    }

    [UIView animateWithDuration:duration delay:0 options:0 animations:^{

        [self.informationLabel setAlpha:0];
        [self.tutorialLabel setAlpha:0];
        [self.tutorialLabel setTransform:CGAffineTransformMakeTranslation(-translation, 0)];
        [self.informationLabel setTransform:CGAffineTransformMakeTranslation(-translation, 0)];

    } completion:^(BOOL finished){

        [self updateLabel];
        [self.informationLabel setTransform:CGAffineTransformMakeTranslation(translation, 0)];
        [self.tutorialLabel setTransform:CGAffineTransformMakeTranslation(translation, 0)];

        [UIView animateWithDuration:duration delay:0 options:0 animations:^{

            [self.informationLabel setAlpha:1];
            [self.tutorialLabel setAlpha:1];
            [self.tutorialLabel setTransform:CGAffineTransformMakeTranslation(0, 0)];
            [self.informationLabel setTransform:CGAffineTransformMakeTranslation(0, 0)];

        } completion:nil];

    }];

    if(indexTutorial == 2) {
        [dataView removeCapta];
        [dataView addActionForButton];

    }

    if(indexTutorial == 3) {
        [dataView removeActionForButton];
        [self.view addGestureRecognizer:self.informationDataGesture];
        [self.view removeGestureRecognizer:leftGesture];
    }

}

- (void)informationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self.view removeGestureRecognizer:self.informationDataGesture];

    [dataView animatedCaptionImageView:0];
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{

        CGAffineTransform transform = dataView.transform;
        dataView.transform = CGAffineTransformScale(transform, 1.2, 1.2);

    } completion:nil];

    [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{

        dataView.allDataView.transform = CGAffineTransformIdentity;
        dataView.allDataView.alpha = 1;


    } completion:^(BOOL finished){

        [dataView.allDataView animatedAllLabel:dataView.allDataView.duration Translation:0 Alpha:1];
        [self.view addGestureRecognizer:closeAllInformationDataGesture];

    }];

}

- (void)closeInformationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self hideInformationData];
    [self.view removeGestureRecognizer:self.closeInformationGesture];
    [self.view addGestureRecognizer:self.informationDataGesture];
    
}

- (void)closeAllInformationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [dataView animatedCaptionImageView:1];
    [dataView.allDataView animatedAllLabel:dataView.allDataView.duration
                               Translation:dataView.allDataView.translation
                                     Alpha:0];

    [UIView animateWithDuration:0.5 delay:dataView.allDataView.duration options:0 animations:^{

        dataView.transform = CGAffineTransformIdentity;
        [dataView scaleInformationView:dataView.allDataView];

    } completion:^(BOOL finished){

        [self.view addGestureRecognizer:self.informationDataGesture];

    }];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha TranslationX:(int)translationX TranslationY:(int)translationY{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(translationX, translationY)];

    } completion:nil];
    
}

- (void)hideInformationData {

    dataView.informationViewActive = NO;

    [dataView animatedCaptionImageView:1];

    [dataView.informationView animatedAllLabel:dataView.informationView.duration
                                   Translation:dataView.informationView.translation
                                         Alpha:0];

    [UIView animateWithDuration:dataView.informationView.duration
                          delay:dataView.informationView.duration
                        options:0 animations:^{

                            [dataView scaleInformationView:dataView.informationView];


                        } completion:nil];

    [UIView animateWithDuration:dataView.informationView.duration delay:0 options:0 animations:^{

        [dataView.hoursLabel setAlpha:0];

    } completion:nil];

    [dataView removeBorderButton];

}

@end
