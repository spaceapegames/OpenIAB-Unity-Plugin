@interface SpaceApe_PaymentQueue : NSObject  <SKPaymentTransactionObserver>
+(void)createQueue;
+(void)destroyQueue;
-(void)stopObserving;
@end
