#!/bin/sh
# daily file and DB backup script 

# constant
scriptPath='/var/www/backup'
syncDirWithS3="${scriptPath}/file/"
tmpDir="${scriptPath}/tmp/"
targetDir='<your target dir>'
backet='<your backet>'
durationDay='10'
mysqlUser='<mysql user>'
mysqlPassword='<mysql password>'

newDate=`date '+%F'`
expireDate=`date --date "${durationDay} day ago" '+%F'`

# compress file 
newZipFile=${newDate}.zip
zip -r $syncDirWithS3$newZipFile $targetDir

# dump db
dumpFileName="${newDate}.sql"
tmpDumpFilePath=$tmpDir$dumpFileName
mysqldump -u $mysqlUser -p$mysqlPassword --all-databases > $tmpDumpFilePath
zip "${syncDirWithS3}${dumpFileName}.zip" $tmpDumpFilePath
rm $tmpDumpFilePath

# delete old files
oldZipFile=${expireDate}.zip
rm $syncDirWithS3$oldZipFile

oldDumpFileName="${expireDate}.sql"
rm "${syncDirWithS3}${oldDumpFileName}.zip"

# sync with S3
aws s3 sync $syncDirWithS3 s3://${backet}/
