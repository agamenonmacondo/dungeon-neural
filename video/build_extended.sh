#!/bin/bash
set -e

DIR="/home/mod/dungeon-neural/video"
AUDIO="$DIR/voiceover_full.mp3"
OUT="$DIR/dungeon_neural_extended.mp4"

cd "$DIR"

# Segment durations (seconds) - calculated from word count proportions
# Total audio: ~345s
# seg01: 17s  seg02: 63s  seg03: 73s  seg04: 43s
# seg05: 43s  seg06: 35s  seg07: 13s  seg08: 41s  seg09: 17s

# For gameplay segments, we split seg05 into desktop gameplay + stats overlay
# and seg07 is mobile gameplay

# Create each segment video with fade in/out
echo "Creating segments..."

# seg01 - Hook (17s)
ffmpeg -y -loop 1 -i seg01.png -c:v libx264 -t 17 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=16.5:d=0.5" \
  seg01_vid.mp4 2>/dev/null
echo "  seg01 done"

# seg02 - Quien soy (63s)
ffmpeg -y -loop 1 -i seg02.png -c:v libx264 -t 63 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=62.5:d=0.5" \
  seg02_vid.mp4 2>/dev/null
echo "  seg02 done"

# seg03 - Alejandro (73s)
ffmpeg -y -loop 1 -i seg03.png -c:v libx264 -t 73 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=72.5:d=0.5" \
  seg03_vid.mp4 2>/dev/null
echo "  seg03 done"

# seg04 - Por que roguelike (43s)
ffmpeg -y -loop 1 -i seg04.png -c:v libx264 -t 43 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=42.5:d=0.5" \
  seg04_vid.mp4 2>/dev/null
echo "  seg04 done"

# seg05 - Lo que construi - gameplay desktop (22s) then stats overlay (21s) = 43s total
ffmpeg -y -loop 1 -i gameplay_desktop_full.png -c:v libx264 -t 22 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=21.5:d=0.5" \
  seg05a_vid.mp4 2>/dev/null

ffmpeg -y -loop 1 -i seg05.png -c:v libx264 -t 21 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=20.5:d=0.5" \
  seg05b_vid.mp4 2>/dev/null

# Concatenate seg05a + seg05b
echo "file 'seg05a_vid.mp4'" > seg05_concat.txt
echo "file 'seg05b_vid.mp4'" >> seg05_concat.txt
ffmpeg -y -f concat -safe 0 -i seg05_concat.txt -c copy seg05_vid.mp4 2>/dev/null
echo "  seg05 done"

# seg06 - Lo que aprendi (35s)
ffmpeg -y -loop 1 -i seg06.png -c:v libx264 -t 35 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=34.5:d=0.5" \
  seg06_vid.mp4 2>/dev/null
echo "  seg06 done"

# seg07 - Movil - mobile gameplay (7s) then text overlay (6s) = 13s
ffmpeg -y -loop 1 -i gameplay_mobile_16x9_v2.png -c:v libx264 -t 7 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=6.5:d=0.5" \
  seg07a_vid.mp4 2>/dev/null

ffmpeg -y -loop 1 -i seg07.png -c:v libx264 -t 6 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=5.5:d=0.5" \
  seg07b_vid.mp4 2>/dev/null

echo "file 'seg07a_vid.mp4'" > seg07_concat.txt
echo "file 'seg07b_vid.mp4'" >> seg07_concat.txt
ffmpeg -y -f concat -safe 0 -i seg07_concat.txt -c copy seg07_vid.mp4 2>/dev/null
echo "  seg07 done"

# seg08 - Libertad (41s)
ffmpeg -y -loop 1 -i seg08.png -c:v libx264 -t 41 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=40.5:d=0.5" \
  seg08_vid.mp4 2>/dev/null
echo "  seg08 done"

# seg09 - Cierre (17s)
ffmpeg -y -loop 1 -i seg09.png -c:v libx264 -t 17 -pix_fmt yuv420p -r 30 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=16:d=1" \
  seg09_vid.mp4 2>/dev/null
echo "  seg09 done"

# Concatenate all segments
echo "Concatenating..."
echo "file 'seg01_vid.mp4'
file 'seg02_vid.mp4'
file 'seg03_vid.mp4'
file 'seg04_vid.mp4'
file 'seg05_vid.mp4'
file 'seg06_vid.mp4'
file 'seg07_vid.mp4'
file 'seg08_vid.mp4'
file 'seg09_vid.mp4'" > final_concat.txt

ffmpeg -y -f concat -safe 0 -i final_concat.txt -c copy video_noaudio.mp4 2>/dev/null

# Add audio with fade-in/fade-out
echo "Adding audio..."
ffmpeg -y -i video_noaudio.mp4 -i "$AUDIO" \
  -c:v copy -c:a aac -b:a 192k \
  -filter_complex "[1:a]afade=t=in:st=0:d=1.5,afade=t=out:st=343:d=2[a]" \
  -map 0:v -map "[a]" \
  -shortest "$OUT" 2>/dev/null

echo "Done!"
ls -la "$OUT"