// test.m
//                           wookay.noh at gmail.com

#import "test.h"

int main (int argc, const char * argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  UnitTest* unittest = [[UnitTest alloc] init];
  [unittest run:@"NSArrayControllerTest"];
  [unittest run:@"NSBoxTest"];
  [unittest run:@"NSViewTest"];
  [unittest run:@"NSMutableAttributedStringTest"];
  [unittest report];

  [pool release];
  return 0;
}
