# FFmpeg-in-Xcode

- A project for debugging FFmpeg and SDL in Xcode.

## Condition

- FFmpeg : 7.1
- SDL : 2.28.5
- Xcode : 16.1
- configuration  : --disable-asm --disable-lzma --disable-filter=yadif_videotoolbox

## Schemes

- Run ffmpeg, ffplay, or ffprobe.

![schemes](https://github.com/libobjc/FFmpeg-in-Xcode/blob/master/snapshot/schemes.png?raw=true)

## Arguments

- Add launch arguments at ‘Edit Scheme’ panel.

![arguments](https://github.com/libobjc/FFmpeg-in-Xcode/blob/master/snapshot/arguments.png?raw=true)

## How to use?

1. Clone this repo.
1. Direct run ffmpeg, ffplay, or ffprobe.

## How to customize?

##### The project provides a tool to simply change the FFmpeg version and configuration.

1. Download FFmpeg source, configure and make.
1. Remove FFmpeg source files from project.
1. Open 'build.m', Replace to your own FFmpeg and project paths.
1. Select scheme to build-1, and run it.
1. Add the files under $(ProjectRoot)/FFmpeg to the project(target is FFmpeg, fftools except).
1. Configure fftools to correct target. Refer to existing project 'Target Membership'.
1. Select scheme to build-2, and run it.
1. Done.

#### You can view snapshot of the key node in the snapshot directory.
