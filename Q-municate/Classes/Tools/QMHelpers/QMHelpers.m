//
//  QMHelpers.m


#import "QMHelpers.h"

BOOL FloatAlmostEqual(double x, double y, double delta) {
    return fabs(x - y) <= delta;
}

