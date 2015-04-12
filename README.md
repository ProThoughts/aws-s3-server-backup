# aws-s3-server-backup
backup DB and files of web server to Amazon S3

# setup aws command
```
$ pip install awscli
$ which aws
/usr/bin/aws
$ aws configure
AWS Access Key ID [None]:
AWS Secret Access Key [None]:
Default region name [None]:
Default output format [None]:
$ aws s3 ls
(your backet will be shown)
```
# setup cron
```
$ crontab -e
10 3 * * * sh /var/www/backup/backup.sh
```

