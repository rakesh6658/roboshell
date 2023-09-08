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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $logfile
yum install mongodb-org -y $>> $logfile
 validate $? "mongodb installation"

 systemctl enable mongod $>> $logfile
 validate $? "mongodb status enable"
 systemctl start mongod $>> $logfile
 validate $? "mongodb start status" 
 sed -i  's/127.0.0.1/0.0.0.0/'  /etc/mongod.conf $>> $logfile
 validate $? "changing mongod.conf"
 systemctl restart mongod $>> $logfile
 validate $? "restarted mongodb"

