/* Abstract:
 
 Default app delegate implementation.
 
 */

@import UIKit;
@import CoreLocation;
@import CoreMotion;
#import "INTULocationManager.h"

@interface AAPLAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager* motionManager;
@property (strong, nonatomic) INTULocationManager* locMgr;


@end
