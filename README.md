# shell_timelapse
A configurable timelapse recorder running from the commandline, merging multiple exposures for a motion blur effect.

Traditional timelapse screenshot tools suffer from producing very jerky video, because they take only one image over each period which doesn't represent the average contents of the screen over that time.

These scripts approach timelapse screen videos from a more photographic perspective, by taking a number of "exposures" throughout the timelapse period, and averaging them together to produce each frame.  For instance, if you'd like to produce a timelapse with one frame of the video covering every minute of realtime (30 minutes realtime per second of video), you can configure this script to take ten exposures per period; it would then take a screenshot every 6 seconds, and average together the results each minute, giving a much smoother "motion-blurred" effect that shows a lot more of what the screen looked like that minute, rather than a single screenshot from one moment during the timelapse period.

The resulting videos look a lot more kinetic and display motion more visibly, with less flicker.

The scripts run with nice and ionice to reduce foreground system load, but the act of taking a screenshot can introduce some noticeable judder on many systems, so I recommend balancing the number of exposures to system load.  Generally anything more than one exposure a second can produce noticeable slowdown.  Between five and ten exposures per frame are usually enough to produce a nice smooth effect.

## Dependencies:
* ImageMagick
* ffmpeg

## Scripts included:
* `screenshot_timelapse.sh` - repeatedly take a series of images over a given period, averaging them together at the end of that period, leaving a series of averaged .screenshots.
* `png_to_video.sh` - produce a youtube-friendly mp4 video from every png file in the current directory.

## Configuration
To change target resolution, recording framerate and exposures per image, and target framerate, just edit those options at the top of their relevant scripts.

## Running
Just execute `./screenshot_timelapse.sh` in your target directory and it'll start producing png images for you there.  You might want to run it in `screen` or something similar.  When you have enough images, convert them to a video for upload using `./png_to_video.sh`.  Simple.

## Sample output
Short sample video, consisting of one real-life minute per frame with 10 intermediate blending exposures per frame (one every six seconds), encoded at 30fps, showing two hours in two seconds:
[![Sample video](http://img.youtube.com/vi/OaFEUzuWS84/0.jpg)](https://youtu.be/OaFEUzuWS84)

An example of a single frame from the above video - combining ten exposures over one minute to get the average overall screen activity during that minute:

[![https://i.sli.mg/Yd7j5z.png](https://i.sli.mg/Yd7j5z.png)](https://i.sli.mg/Yd7j5z.png)
