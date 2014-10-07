/*
Abstract:

     Main view for Motion Activity app.  This shows a list of the 7 days from which
     user activity and step counting data is available.
  
*/

@import UIKit;
#import "LocationHandler.h"

@interface AAPLMasterViewController : UITableViewController<LocationHandlerDelegate>

@end
