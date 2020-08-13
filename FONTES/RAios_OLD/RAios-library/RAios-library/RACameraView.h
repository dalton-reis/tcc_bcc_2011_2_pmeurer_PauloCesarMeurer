/*!
 *  RACameraView.h
 *  FURB RA
 *
 *  Created by Paulo Cesar Meurer on 8/9/11.
 *
 *  Classe criada para acessar diretamente a câmera do iPhone utilizando o SDK 4
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface RACameraView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureSession            *m_captureSession;
    AVCaptureVideoPreviewLayer  *m_prevLayer; 
    //UIImageView                 *m_imageView;
    UIView                      *m_parentView;
    
@public
    CMTime                      m_raCameraFrameRate;
    NSString                    *m_raCameraQualidadeCaptura;
}

// Inicializa a sessão de captura de vídeo
- (void)initCapture:(UIView*)parentView;

// Encerra a captura de vídeo
- (void)stopCapture;

@end
