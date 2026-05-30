#!/bin/bash
set -e

DIR="/home/mod/dungeon-neural/video"
AUDIO="$DIR/../voiceover.mp3"
OUT="$DIR/dungeon_neural_final.mp4"

cd $DIR

# Durations per segment (total ~94s)
D1=13; D2=22; D3=20; D4=13; D5=7; D6=13; D7=6
FADE=1  # 1 second crossfade

# Create segments with proper encoding
for i in 1 2 3 4 5 6 7; do
  IMG=""
  DUR=""
  case $i in
    1) IMG="frame01.png"; DUR=$D1 ;;
    2) IMG="frame02.png"; DUR=$D2 ;;
    3) IMG="frame03.png"; DUR=$D3 ;;
    4) IMG="gameplay_explore.png"; DUR=$D4 ;;
    5) IMG="gameplay_mobile_16x9.png"; DUR=$D5 ;;
    6) IMG="frame05.png"; DUR=$D6 ;;
    7) IMG="frame06.png"; DUR=$D7 ;;
  esac
  
  TOTAL=$(echo "$DUR + 2" | bc)
  # Each segment: fade in from black 0.5s, fade out to black 0.5s
  FADEIN=0.5
  FADEOUT_START=$(echo "$DUR - 0.5" | bc)
  ffmpeg -y -loop 1 -i "$IMG" \
    -c:v libx264 -t "$DUR" -pix_fmt yuv420p -r 30 \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,fade=in:0:15,fade=out:st=${FADEOUT_START}:d=0.5" \
    "seg${i}.mp4" 2>/dev/null
done

# Concatenate with xfade filter between segments
# Total: 13+22+20+13+7+13+6 = 94s
# With 0.5s crossfades (6 transitions x 0.5s = -3s) = 91s... too short
# Let's just concat with fade transitions

echo "file 'seg1.mp4'
file 'seg2.mp4'
file 'seg3.mp4'
file 'seg4.mp4'
file 'seg5.mp4'
file 'seg6.mp4'
file 'seg7.mp4'" > concat.txt

ffmpeg -y -f concat -safe 0 -i concat.txt -c copy video_noaudio.mp4 2>/dev/null

# Add audio with proper mixing
ffmpeg -y -i video_noaudio.mp4 -i "$AUDIO" \
  -c:v copy -c:a aac -b:a 192k \
  -filter_complex "[1:a]afade=t=in:st=0:d=1,afade=t=out:st=92:d=2[a]" \
  -map 0:v -map "[a]" \
  -shortest "$OUT" 2>/dev/null

echo "Done!"
ls -la "$OUT"