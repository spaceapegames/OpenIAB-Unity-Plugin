#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "SpaceApe_PaymentQueue.h"
#import "AppStoreDelegate.h"

#define MakeStringCopy( _x_ ) ( _x_ != NULL && [_x_ isKindOfClass:[NSString class]] ) ? strdup( [_x_ UTF8String] ) : NULL


void UnitySendMessage( const char * className, const char * methodName, const char * param );

extern "C"
{
    void _InitPaymentQueue()
    {
        [SpaceApe_PaymentQueue createQueue];
    }
    
    void _DestroyPaymentQueue()
    {
        [SpaceApe_PaymentQueue destroyQueue];
    }
}



@implementation SpaceApe_PaymentQueue

bool observing;

static NSMutableArray* RecordedTransactions;

+ (SpaceApe_PaymentQueue*)instance
{
	static SpaceApe_PaymentQueue* instance = nil;
	if (!instance)
		instance = [[SpaceApe_PaymentQueue alloc] init];
    
    return instance;
}


+ (void)createQueue
{
    [[SpaceApe_PaymentQueue instance] startObserving];
}

+ (void)destroyQueue
{
    [[SpaceApe_PaymentQueue instance] stopObserving];
    
    if(RecordedTransactions != nil)
    {
        if([AppStoreDelegate hasInstance])
        {
            [[AppStoreDelegate instance] paymentQueue:nil updatedTransactions:RecordedTransactions];
        }
        RecordedTransactions = nil;
    }
}

- (id)init
{
    self = [super init];
    return self;
}

- (void)startObserving
{
    if(!observing)
    {
        observing = true;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
}

- (void)stopObserving
{
    if(observing)
    {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        observing = false;
    }
}


// Transactions handler
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    if(RecordedTransactions == nil)
    {
        RecordedTransactions = [[NSMutableArray alloc] init];
    }
    for (SKPaymentTransaction *transaction in transactions)
    {
        [RecordedTransactions addObject:transaction];
    }
}

- (void)paymentQueue:(SKPaymentQueue*)queue restoreCompletedTransactionsFailedWithError:(NSError*)error
{
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue*)queue
{
}


@end





