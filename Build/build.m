//
//  build-1.m
//  build-1
//
//  Created by Single on 2018/11/8.
//  Copyright © 2018 Single. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL SGFCopy(NSString *s, NSString *d, BOOL force)
{
    BOOL dir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:s isDirectory:&dir] || ([fm fileExistsAtPath:d] && !force)) {
        return NO;
    }
    [fm removeItemAtPath:d error:nil];
    NSMutableArray *c = [d.pathComponents mutableCopy];
    [(NSMutableArray *)c removeLastObject];
    for (int i = 0; i < c.count; i++) {
        NSArray *c_t = [c subarrayWithRange:NSMakeRange(0, c.count - i)];
        NSString *p = [NSString pathWithComponents:c_t];
        if (![fm fileExistsAtPath:p]) {
            [fm createDirectoryAtPath:p withIntermediateDirectories:yearMask attributes:nil error:nil];
        }
    }
    [fm copyItemAtPath:s toPath:d error:nil];
    return YES;
}

BOOL SGFCopyExt(NSString *s, NSString *d, BOOL force, NSString *e, NSArray<NSString *> *es)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *o in [fm enumeratorAtPath:s]) {
        NSString *p = [s stringByAppendingPathComponent:o];
        if ([o hasSuffix:e]) {
            NSString *r = p;
            if (es.count) {
                r = nil;
                for (NSString *m in es) {
                    r = [p stringByReplacingOccurrencesOfString:e withString:m];
                    if ([fm fileExistsAtPath:r]) {
                        break;
                    }
                }
            }
            if (!r) {
                NSLog(@"Not Found : %@", o);
                return NO;
            }
            NSString *t = [r stringByReplacingOccurrencesOfString:s withString:d];
            SGFCopy(r, t, force);
        }
    };
    return YES;
}

BOOL SGFRemove(NSString *s)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:s]) {
        return [fm removeItemAtPath:s error:nil];
    }
    return NO;
}

BOOL SGFReplace(NSString *s, NSString *f, NSString *t)
{
    BOOL dir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:s isDirectory:&dir] || dir) {
        return NO;
    }
    NSString *c = [NSString stringWithContentsOfFile:s encoding:NSUTF8StringEncoding error:nil];
    if (c.length == 0) {
        return NO;
    }
    c = [c stringByReplacingOccurrencesOfString:f withString:t];
    return [c writeToFile:s atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

NSString * SGFAppend(NSString *s, NSString *a)
{
    return [s stringByAppendingPathComponent:a];
}

/**
 *  Remove : libavutil   ---> time.h
 *  Edit   : libavcodec  ---> videotoolbox.c
 *           libavfilter ---> vsrc_mandelbrot.c
 */
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *s = @"/Users/gary/Desktop/Coding/FFmpeg/";
        NSString *d = @"/Users/gary/Desktop/Coding/FFmpeg-in-Xcode/FFmpeg/";
        
        NSArray * dirs = @[@"fftools",
                           @"libavcodec",
                           @"libavdevice",
                           @"libavfilter",
                           @"libavformat",
                           @"libavresample",
                           @"libavutil",
                           @"libpostproc",
                           @"libswresample",
                           @"libswscale"];
        if (argc < 2) {
            return 0;
        }
        if (strcmp(argv[1], "build-1") == 0) {
            // Clean
            for (NSString * o in dirs) {
                SGFRemove(SGFAppend(d, o));
            }
            SGFRemove(SGFAppend(d, @"compat"));
            SGFRemove(SGFAppend(d, @"config.h"));
            // Copy
            for (NSString * o in dirs) {
                SGFCopyExt(SGFAppend(s, o), SGFAppend(d, o), YES, @".h", nil);
                SGFCopyExt(SGFAppend(s, o), SGFAppend(d, o), YES, @".o", @[@".c", @".m"]);
            }
            SGFCopy(SGFAppend(s, @"config.h"), SGFAppend(d, @"config.h"), YES);
            SGFRemove(SGFAppend(d, @"libavutil/time.h"));
        }
        if (strcmp(argv[1], "build-2") == 0) {
            // Copy
            for (NSString * o in dirs) {
                SGFCopyExt(SGFAppend(s, o), SGFAppend(d, o), YES, @".h", nil);
                SGFCopyExt(SGFAppend(s, o), SGFAppend(d, o), YES, @".c", nil);
                SGFCopyExt(SGFAppend(s, o), SGFAppend(d, o), YES, @".inc", nil);
            }
            SGFCopyExt(SGFAppend(s, @"compat"), SGFAppend(d, @"compat"), YES, @".h", nil);
            SGFCopyExt(SGFAppend(s, @"compat"), SGFAppend(d, @"compat"), YES, @".c", nil);
            // Edit
            SGFReplace(SGFAppend(d, @"libavcodec/videotoolbox.c"),
                       @"#include \"mpegvideo.h\"",
                       @"// Edit by Single\n#define Picture FFPicture\n#include \"mpegvideo.h\"\n#undef Picture");
            SGFReplace(SGFAppend(d, @"libavfilter/vsrc_mandelbrot.c"),
                       @"typedef struct Point {",
                       @"// Edit by Single\ntypedef struct {");
            SGFReplace(SGFAppend(d, @"libavdevice/sdl2.c"),
                       @"#include <SDL.h>",
                       @"// Edit by Single\n#include <SDL2/SDL.h>");
            SGFReplace(SGFAppend(d, @"libavdevice/sdl2.c"),
                       @"#include <SDL_thread.h>",
                       @"// Edit by Single\n#include <SDL2/SDL_thread.h>");
            SGFReplace(SGFAppend(d, @"fftools/ffplay.c"),
                       @"#include <SDL.h>",
                       @"// Edit by Single\n#include <SDL2/SDL.h>");
            SGFReplace(SGFAppend(d, @"fftools/ffplay.c"),
                       @"#include <SDL_thread.h>",
                       @"// Edit by Single\n#include <SDL2/SDL_thread.h>");
        }
    }
    return 0;
}
