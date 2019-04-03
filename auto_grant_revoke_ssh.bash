#!/bin/bash
user=$1
task=$2
home_dir="/home/$user"
keypath="/home/$1/.ssh/"
authorized_path="/home/$1/.ssh/authorized_keys"
id_rsa="/home/$1/.ssh/$user"
id_rsa_pub="/home/$1/.ssh/$user.pub"

#puprose of the function is to create a user and provide user access with a key
create_user(){
user1=$1
useradd $user1
su -l $user1 -c `ssh-keygen -t rsa -f` "$keypath/$id_rsa"
mkdir -p $keypath
mv $home_dir/$user* $keypath
touch $authorized_path
cat $id_rsa_pub >$authorized_path
chown $user.$user $keypath $authorized_path
chmod 600 $authorized_path 
restart_ssh
}

/etc/init.d/sshd restart
#mail alert
mail_alert(){
    mail_path="/usr/bin/mail"
    if [ -f $mail_path ]
        then
   cat id_rsa | mail -s "$user Access key for $hostname" chhatralasagar99@gmail.com
else
    echo " mail client is not available "
fi

}

if [ $# -eq 2 ]
        then
        if [ "$task" = "G" ]
                then 
                echo "Granting SSH access to $user"
        #echo "$id_rsa"
                create_user $user
                echo "Use this key to access the server"
                echo "##############################"
                echo "Access key for $username"
                cat $id_rsa

       fi
                if [ "$task" = "R" ]
                        then
                        echo "Revoking SSH Access to $user"
                        rm -f $user $authorized_path
       fi
else
        echo " Two inputs required"
        echo " 1) Username"
        echo " 2) G or R ( 'G' for GRANT SSH access Or 'R' for Revoke SSH access) "
fi
