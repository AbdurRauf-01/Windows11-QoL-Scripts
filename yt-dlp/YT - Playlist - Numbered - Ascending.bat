@echo off
cd /d C:\ytdl

echo Checking for yt-dlp updates...
yt-dlp -U
echo.

:START
set /p URL=Enter video URL (or type EXIT): 
if /i "%URL%"=="EXIT" exit

yt-dlp -f "bv*[height<=1080][fps<=60]+ba/b[height<=1080][fps<=60]/b" ^
--merge-output-format mp4 ^
-o "%%(playlist_title,unknown,restrict_filenames)s/%%(playlist_index)02d. %%(title,restrict_filenames)s.%%(ext)s" ^
--write-subs ^
--sub-langs en ^
--skip-unavailable-fragments ^
--retries 3 ^
--fragment-retries 3 ^
--retry-sleep 5 ^
--continue ^
-P "D:\Users\Abdur Rauf\Downloads\yt-dlp" ^
--download-archive "C:\Users\Abdur Rauf\Documents\Configurations\yt-dlp\History\Downloaded.txt" ^
--print-to-file "playlist_autonumber,playlist_index,title,id,webpage_url,playlist_title,playlist_id,channel,channel_id,upload_date,resolution,fps,vcodec,acodec,ext,filename" "D:\Users\Abdur Rauf\Downloads\yt-dlp\%%(playlist_title,unknown,restrict_filenames)s/%%(playlist_title,unknown,restrict_filenames)s - Info.txt" ^
"%URL%"

echo.
echo Download Complete!
pause