/**
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2015 Jens Meder
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of
 *	this software and associated documentation files (the "Software"), to deal in
 *	the Software without restriction, including without limitation the rights to
 *	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *	the Software, and to permit persons to whom the Software is furnished to do so,
 *	subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in all
 *	copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "AppDelegate.h"
#import "JMConcreteRootViewModel.h"
#import "JMRootViewController.h"
#import <DarkLightning/JMUSBDeviceManager.h>

@implementation AppDelegate
{
	@private
	
	NSWindow* _mainWindow;
	JMUSBDeviceManager* _deviceManager;
	NSProcessInfo* _processInfo;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_deviceManager = [[JMUSBDeviceManager alloc]init];
	
	JMConcreteRootViewModel* viewModel = [[JMConcreteRootViewModel alloc]initWithDeviceManager:_deviceManager];
	JMRootViewController* viewController = [[JMRootViewController alloc]initWithViewModel:viewModel];
	
	_mainWindow = [[NSWindow alloc]initWithContentRect:NSMakeRect(40, -500, 600, 400) styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask backing:NSBackingStoreBuffered defer:YES];
	_mainWindow.contentViewController = viewController;
	
	[_mainWindow makeKeyAndOrderFront:nil];
	
	[_deviceManager start];
	
	_processInfo = [[NSProcessInfo alloc]init];
	[_processInfo beginActivityWithOptions:NSActivityUserInitiated reason:@"asd"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[_deviceManager stop];
}

@end
