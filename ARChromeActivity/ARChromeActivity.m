/*
  ARChromeActivity.m

  Copyright (c) 2013 Alex Ruperez
 
  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/


#import "ARChromeActivity.h"

@implementation ARChromeActivity

- (NSString *)activityType
{
	return NSStringFromClass([self class]);
}

- (UIImage *)activityImage {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [UIImage imageNamed:[self.activityType stringByAppendingString:@"-iPad"]];
    } else {
        return [UIImage imageNamed:self.activityType];
    }
}

- (NSString *)activityTitle {
  return NSLocalizedStringFromTable(@"Open in Chrome", NSStringFromClass([self class]), nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome:"]]) {
			return YES;
		}
	}
    
	return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome:"]]) {
			self.url = activityItem;
		}
	}
}

- (void)performActivity {
    bool completed = NO;
	NSURL *inputURL = self.url;
	NSString *scheme = inputURL.scheme;
	
	// Replace the URL Scheme with the Chrome equivalent.
	NSString *chromeScheme = nil;
	if ([scheme isEqualToString:@"http"]) {
		chromeScheme = @"googlechrome";
	} else if ([scheme isEqualToString:@"https"]) {
		chromeScheme = @"googlechromes";
	}
	
	// Proceed only if a valid Google Chrome URI Scheme is available.
	if (chromeScheme) {
		NSString *absoluteString = [inputURL absoluteString];
		NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
		NSString *urlNoScheme = [absoluteString substringFromIndex:rangeForScheme.location];
		NSString *chromeURLString = [chromeScheme stringByAppendingString:urlNoScheme];
		NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
		
		// Open the URL with Chrome.
		completed = [[UIApplication sharedApplication] openURL:chromeURL];
	}
    
    [self activityDidFinish:completed];
}

@end
