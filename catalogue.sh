#!/bin/bash
dir=/tmp
date=$(date +%F)
script=$0
logfile=$dir/$script/$date.log
echo "$logfile"
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

userid=$(id -u)
if [ $userid -ne 0 ]
then
echo "user is not root user"
exit 1
else
echo "user is root user"
fi
validate(){
    if [ $1 -ne 0 ]
    then 
    echo -e "$2 installation .. $R failure $N"
    else
     echo -e "$2 installation .. $G success $N"
     fi  
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash $>> $logfile
validate $? "downloading rpm source"

yum install nodejs -y $>> $logfile
validate $? "nodejs installation"

useradd roboshop $>> $logfile
validate $? "adding user roboshop"

mkdir /app $>> $logfile
validate $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip $>> $logfile

validate $? "downloading catalogue.zip"
cd /app $>> $logfile
validate $? "moving to app directory"
unzip /tmp/catalogue.zip $>> $logfile
validate $? "unzip catalogue.zip"

npm install  $>> $logfile
validate $? "installing npm"



cp /home/centos/roboshell/catalogue.service /etc/systemd/system/catalogue.service $>> $logfile
validate $? "coping catalogue.service"

systemctl daemon-reload $>> $logfile
validate $? "daemon-reload"

systemctl enable catalogue $>> $logfile
validate $? "enable catalogue"

systemctl start catalogue $>> $logfile
validate $? "started catalogue"

cp mongo.repo /etc/yum.repos.d/mongo.repo $>> $logfile
validate $? "modified mongo.repo"

yum install mongodb-org-shell -y $>> $logfile

validate $? "installed mongodb client"


mongo --host mongodb.lakshman.tech </app/schema/catalogue.js $>> $logfile
validate $? "loaded schema"

