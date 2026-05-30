#!/bin/bash
set -e

DIR="/home/mod/dungeon-neural/video"
AUDIO="$DIR/../voiceover.mp3"
OUT="$DIR/dungeon_neural_final.mp4"

# Segment durations (total ~94s to match audio)
# 1: Hook (0-13s) - frame01
# 2: Alejandro (13-35s) - frame02
# 3: La IA (35-55s) - frame03
# 4: Gameplay (55-68s) - explore
# 5: Gameplay mobile (68-75s) - mobile  
# 6: Libertad (75-88s) - frame05
# 7: Cierre (88-94s) - frame06

# Create individual segment videos with smooth crossfade
cd $DIR

# Segment 1: Hook (13s)
ffmpeg -y -loop 1 -i frame01.png -c:v libx264 -t 13 -pix_fmt yuv420p -r 24 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black" seg1.mp4 2>/dev/null

# Segment 2: Alejandro (22s)
ffmpeg -y -loop 1 -i frame02.png -c:v libx264 -t 22 -pix_fmt yuv420p -r 24 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black" seg2.mp4 2>/dev/null

# Segment 3: La IA (20s)
ffmpeg -y -loop 1 -i frame03.png -c:v libx264 -t 20 -pix_fmt yuv420p -r 24 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black" seg3.mp4 2>/dev/null

# Segment 4: Gameplay desktop (13s)
ffmpeg -y -loop 1 -i gameplay_explore.png -c:v libx264 -t 13 -pix_fmt yuv420p -r 24 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black" seg4.mp4 2>/dev/null

# Segment 5: Gameplay mobile (7s)
ffmpeg -y -loop 1 -i gameplay_mobile_16x9.png -c:v libx264 -t 7 -pix_fmt yuv420p -r 24 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black" seg5.mp4 2>/dev/null

# Segment 6: Libertad (13s)
ffmpeg -y -loop 1 -i frame05.png -c:v libx264 -t 13 -pix_fmt yuv420p -r 24 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black" seg6.mp4 2>/dev/null

# Segment 7: Cierre (6s)
ffmpeg -y -loop 1 -i frame06.png -c:v libx264 -t 6 -pix_fmt yuv420p -r 24 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black" seg7.mp4 2>/dev/null

# Concatenate all segments
echo "file 'seg1.mp4'
file 'seg2.mp4'
file 'seg3.mp4'
file 'seg4.mp4'
file 'seg5.mp4'
file 'seg6.mp4'
file 'seg7.mp4'" > concat.txt

ffmpeg -y -f concat -safe 0 -i concat.txt -c copy video_noaudio.mp4 2>/dev/null

# Add audio
ffmpeg -y -i video_noaudio.mp4 -i "$AUDIO" -c:v copy -c:a aac -b:a 192k -shortest "$OUT" 2>/dev/null

echo "Done! Output: $OUT"
ls -la "$OUT"