#!/usr/bin/env python3
"""Set custom thumbnail for YouTube video."""
import json
import os
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from google.auth.transport.requests import Request

CREDS_DIR = '/home/mod/.hermes/credentials'

with open(os.path.join(CREDS_DIR, 'yt_tokens.json')) as f:
    token_data = json.load(f)

with open(os.path.join(CREDS_DIR, 'yt_client_id.txt')) as f:
    client_id = f.read().strip()

with open(os.path.join(CREDS_DIR, 'yt_client_secret.txt')) as f:
    client_secret = f.read().strip()

credentials = Credentials(
    token=token_data.get('token', token_data.get('access_token')),
    refresh_token=token_data['refresh_token'],
    client_id=client_id,
    client_secret=client_secret,
    token_uri='https://oauth2.googleapis.com/token',
)

if credentials.expired or not credentials.valid:
    credentials.refresh(Request())

youtube = build('youtube', 'v3', credentials=credentials)

# Use frame01 (title card) as thumbnail
THUMB_PATH = '/home/mod/dungeon-neural/video/frame01.png'
VIDEO_ID = 'iaKIDZL0Li4'

youtube.thumbnails().set(
    videoId=VIDEO_ID,
    media_body='/home/mod/dungeon-neural/video/frame01.png'
).execute()

print("Thumbnail set successfully!")