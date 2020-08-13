//
//  RAios_sampleViewController.h
//  RAios-sample
//
//  Created by Paulo Cesar Meurer on 11/7/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "RAios.h"
#import "FerramentasView.h"

@interface RAios_sampleViewController : UIViewController {
    // Biblioteca de RA
    RAios          *m_RAios;
    
    // View de ferramentas
    FerramentasView     *m_ferramentasView;
    CGAffineTransform   m_originalTransform;
    
    // Atributos auxiliares
    CGFloat             m_fViewHeight;
    CGFloat             m_fViewWidth; 
}

- (IBAction)onButtonRealidadeAumentada:(id)sender;
- (IBAction)onButtonConfiguracao:(id)sender;

@end
