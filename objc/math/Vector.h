// Vector.h
//                           wookay.noh at gmail.com

#import <QuartzCore/CIVector.h>

@interface Vector : CIVector {
}
- (float) length ;
- (id) normalize ;
- (id) plus:(id)vector ;
- (id) minus:(id)vector ;
- (id) scale:(float)k ;
- (float) dot_product:(id)vector ;
- (id) cross_product:(Vector*)vector ;
- (id) projection:(Vector*)vector ;

+ (id) vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z ; 
@end