// NSCountedSetTest.m
//                           wookay.noh at gmail.com

#import "test.h"

@implementation TestSuite (NSCountedSet)

- (void) test_NSCountedSet {

  NSCountedSet* set = [NSCountedSet set];
  [set addObject:@"a"];
  [set addObject:@"a"];
  [set addObject:@"a"];
  [set addObject:@"b"];
  //assert_equal(hasSuffix:@"(a [3], b [1])" b:set];
  assert_equal(2, [set count]);
  assert_equal(3, [set countForObject:@"a"]);

  [set removeObject:@"a"];
  //assert_equal hasSuffix:@"(a [2], b [1])" b:set];
  assert_equal(2, [set countForObject:@"a"]);

  [set unionSet:[NSSet setWithObjects:@"a", @"b", @"c", nil]];
  //assert_equal hasSuffix:@"(a [3], b [2], c [1])" b:set];

}

@end
