#pragma Availability Check
+ (BOOL)checkAvailability
{
	return FALSE;
}

#pragma Setup
- (void)_initMotionActivity
{
}

- (void)checkAuthorization:(void (^)(BOOL authorized))authorizationCheckCompletedHandler
{
}

#pragma Historical Query (Pull interface)
- (void)queryHistoricalDataFrom:(NSDate *)startDate toDate:(NSDate *)endDate
{
}

#pragma Live Updates (Push interface)
// Pedometer updates
- (void)startStepUpdates:(AAPLStepUpdateHandler)handler;
{
}

- (void)stopStepUpdates
{
}

// Motion updates
- (void)startMotionUpdates:(AAPLMotionUpdateHandler)handler
{
}

- (void)stopMotionUpdates;
{
}

