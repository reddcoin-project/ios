//
//  RDDScanViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/13/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDScanViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface RDDScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@end

@implementation RDDScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self isCameraAvailable]) {
        // Camera = device can scan
        [self setupCapture];
    } else {
        // No camera
        [self showNoCameraAlert];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.preview.frame = self.view.bounds;
    [self updateVideoOrientation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)tappedCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)isCameraAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return [videoDevices count] > 0;
}

- (void)showNoCameraAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Device Camera"
                                message:@"This device does not have a compatible camera for scanning."
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

- (void)setupCapture
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session addOutput:output];
    [self.session addInput:input];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.bounds;
    
    [self updateVideoOrientation];
    [self.view.layer insertSublayer:self.preview atIndex:0];
}

- (void)updateVideoOrientation
{
    AVCaptureVideoOrientation newOrientation;
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:
            newOrientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            newOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            newOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            newOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            newOrientation = AVCaptureVideoOrientationPortrait;
    }
    AVCaptureConnection *con = self.preview.connection;
    con.videoOrientation = newOrientation;
}

- (void)playVibrateConfirmation
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            if ([self.delegate respondsToSelector:@selector(rddScanViewController:didScan:)]) {
                [self.session stopRunning];
                self.session = nil;
                
                [self playVibrateConfirmation];
                
                NSString *value = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
                [self.delegate rddScanViewController:self didScan:value];
            }
        }
    }
}

@end
