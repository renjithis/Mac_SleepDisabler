//
//  main.m
//  SleepDisabler
//
//  Created by Renjith on 31/10/12.
//  Copyright (c) 2012 Renjith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import <IOKit/IOMessage.h>
#include <asl.h>

void callback(void * x,io_service_t y,natural_t messageType,void *messageArgument);

io_connect_t        groot_port;

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        asl_log(NULL, NULL, (ASL_LEVEL_NOTICE), "%s", "SleepDisabler started");
        NSLog(@"Start");
        IONotificationPortRef    notify;
        io_object_t         anIterator;
        
        groot_port = IORegisterForSystemPower(0,&notify,callback,&anIterator);
        if ( groot_port == 0 ) {
            asl_log(NULL, NULL, (ASL_LEVEL_ERR), "%s", "IORegisterForSystemPower failed");

//            printf("IORegisterForSystemPower failed\n");
//            return 1;
        }
        
        IOReturn assertionStatus;
        IOPMAssertionID preventSystemSleepAssertionID,preventIdleSleepAssertionID;
//        IOPMAssertionCreateWithName(<#CFStringRef AssertionType#>, <#IOPMAssertionLevel AssertionLevel#>, <#CFStringRef AssertionName#>, <#IOPMAssertionID *AssertionID#>)
        CFStringRef preventSystemSleepStringRef=CFStringCreateWithCString(NULL, "preventSystemSleep", NSUTF8StringEncoding);
        CFStringRef noIdleSleepStringRef=CFStringCreateWithCString(NULL, "noIdleSleep", NSUTF8StringEncoding);
        assertionStatus=IOPMAssertionCreateWithName(kIOPMAssertionTypePreventSystemSleep, kIOPMAssertionLevelOn, preventSystemSleepStringRef, &preventSystemSleepAssertionID);
        if(assertionStatus != kIOReturnSuccess)
        {
            NSLog(@"ERROR");
            asl_log(NULL, NULL, (ASL_LEVEL_ERR), "%s", "Unable to create PMAssertion with type kIOPMAssertionTypePreventSystemSleep");
        }
        assertionStatus=IOPMAssertionCreateWithName(kIOPMAssertionTypeNoIdleSleep, kIOPMAssertionLevelOn, noIdleSleepStringRef, &preventIdleSleepAssertionID);
        if(assertionStatus != kIOReturnSuccess)
        {
            NSLog(@"ERROR");
            asl_log(NULL, NULL, (ASL_LEVEL_ERR), "%s", "Unable to create PMAssertion with type kIOPMAssertionTypeNoIdleSleep");
        }
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(),
                           IONotificationPortGetRunLoopSource(notify),
                           kCFRunLoopDefaultMode);
        
        asl_log(NULL, NULL, (ASL_LEVEL_NOTICE), "%s", "Prevention of system sleep enabled");

        
        NSRunLoop *runLoop=[NSRunLoop currentRunLoop];
        [runLoop run];
    }
    return 0;
}

void callback(void * x,io_service_t y,natural_t messageType,void *messageArgument)
{
    switch ( messageType ) {
        case kIOMessageSystemWillSleep:
            // COMPUTER WILL GO TO SLEEP.
            asl_log(NULL, NULL, (ASL_LEVEL_WARNING), "%s", "kIOMessageSystemWillSleep received");

//            IOAllowPowerChange(groot_port,(long)messageArgument);
            break;
        case kIOMessageCanSystemSleep:
            // Add code to decide whether to allow sleep or not.
            //        IOCancelPowerChange(groot_port,(long)messageArgument);
//            IOAllowPowerChange(groot_port,(long)messageArgument);
            IOCancelPowerChange(groot_port,(long)messageArgument);
            asl_log(NULL, NULL, (ASL_LEVEL_NOTICE), "%s", "System asking for permission to sleep");

            break;
        case kIOMessageSystemHasPoweredOn:
            asl_log(NULL, NULL, (ASL_LEVEL_NOTICE), "%s", "System returned from sleep");
            break;
    }
    
}
