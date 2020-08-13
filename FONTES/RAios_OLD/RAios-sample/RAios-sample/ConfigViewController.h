//
//  ConfigViewController.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 9/13/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfigViewController : UIViewController {
    UILabel *labelSliderDistanciaPOI;
    UILabel *labelSliderDistanciaAtuGPS;
    
    UISlider *sliderDistanciaPOI;
    UISlider *sliderDistanciaAtuGPS;
    
    UISwitch *switchFPS;
    UISwitch *switchTextura;
    
    UITextField *textObjetosSimu;
}

@property (nonatomic, retain) IBOutlet UILabel *labelSliderDistanciaPOI;
@property (nonatomic, retain) IBOutlet UILabel *labelSliderDistanciaAtuGPS;
@property (nonatomic, retain) IBOutlet UISlider *sliderDistanciaPOI;
@property (nonatomic, retain) IBOutlet UISlider *sliderDistanciaAtuGPS;
@property (nonatomic, retain) IBOutlet UISwitch *switchFPS;
@property (nonatomic, retain) IBOutlet UISwitch *switchTextura;
@property (nonatomic, retain) IBOutlet UITextField *textObjetosSimu;

- (IBAction)onButtonSalvar:(id)sender;
- (IBAction)sliderPOIChanged:(id)sender;
- (IBAction)sliderGPSChanged:(id)sender;
- (IBAction)backgroundTap:(id)sender;

- (void)salvarConfiguracao;
- (void)carregarConfiguracao;

@end
