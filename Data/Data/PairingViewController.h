//
//  PairingViewController.h
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFRWebSocket.h"
#import "PlayerView.h"
#import "PairingImageContentView.h"

@interface PairingViewController : UIViewController<JFRWebSocketDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationParringLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet PairingImageContentView *pairingImageContentView;

@property (weak, nonatomic) IBOutlet PlayerView *playerView;

@property(nonatomic) JFRWebSocket *socket;

@end
