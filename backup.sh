#!/bin/sh
# daily file and DB backup script 

# constant
syncDirWithS3='./file/'
tmpDir='./tmp/'
targetDir='<your target dir>'
backet='<your backet>'
durationDay='10'
mysqlUser='<mysql user>'
mysqlPassword='<mysql password>'

newDate=`date '+%F'`
expireDate=`date --date "${durationDay} day ago" '+%F'`

# file
newZipFile=${newDate}.zip
zip -r $syncDirWithS3$newZipFile $targetDir

# db
dumpFileName="${newDate}.sql"
tmpDumpFilePath=$tmpDir$dumpFileName
mysqldump -u $mysqlUser -p$mysqlPassword --all-databases > $tmpDumpFilePath
zip "${syncDirWithS3}${dumpFileName}.zip" $tmpDumpFilePath
rm $tmpDumpFilePath

# sync with S3
aws s3 sync $syncDirWithS3 s3://${backet}/
