//
//  ViewController.h
//  ShowSystemInfo
//
//  Created by licrifan on 2022/11/4.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)nameBtnClicked:(UIButton *)sender;
- (IBAction)systemNameBtnClicked:(UIButton *)sender;
- (IBAction)sysVerCBtnlicked:(UIButton *)sender;
- (IBAction)modelBtnClicked:(UIButton *)sender;

- (IBAction)sysctlBtnClicked:(UIButton *)sender;

- (IBAction)idfvBtnClicked:(UIButton *)sender;

- (IBAction)carrierBtnClicked:(UIButton *)sender;
- (IBAction)statusCarrierBtnClicked:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *systemNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *systemVersionLbl;
@property (weak, nonatomic) IBOutlet UILabel *modelLbl;

@property (weak, nonatomic) IBOutlet UILabel *hwMachineLbl;
@property (weak, nonatomic) IBOutlet UILabel *generationLbl;
@property (weak, nonatomic) IBOutlet UILabel *variantLbl;
@property (weak, nonatomic) IBOutlet UILabel *aNumberLbl;

@property (weak, nonatomic) IBOutlet UILabel *idfvLbl;

@property (weak, nonatomic) IBOutlet UILabel *allowVoipLbl;
@property (weak, nonatomic) IBOutlet UILabel *carrierNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *iccLbl;
@property (weak, nonatomic) IBOutlet UILabel *mccLbl;
@property (weak, nonatomic) IBOutlet UILabel *mncLbl;

@property (weak, nonatomic) IBOutlet UILabel *statusServiceStrLbl;

@end

