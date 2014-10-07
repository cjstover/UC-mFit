/*
Abstract:

     MotionActivityQuery to encapsulate the data needed for a single query against
     the motion activity db.
  
*/

@import Foundation;

@interface AAPLMotionActivityQuery : NSObject

@property (readonly, nonatomic) NSDate *startDate;
@property (readonly, nonatomic) NSDate *endDate;
@property (readonly, nonatomic) BOOL isToday;

+ (AAPLMotionActivityQuery *)queryStartingFromDate:(NSDate *)date offsetByDay:(NSInteger)offset;
- (NSString *)description;

@end
