#!/bin/sh

CATALINA_HOME=~/tomcat
CATALINA_BASE=~/tomcat

TOMCAT_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;31mkill\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"
SHUTDOWN_WAIT=20
STARTUP_WAIT=50

tomcat_pid() {
    echo `ps -fe | grep $CATALINA_BASE | grep -v grep | tr -s " "|cut -d" " -f2`
}

start() {
    pid=$(tomcat_pid)
    if [ -n "$pid" ]
    then
        echo -e "\e[00;31mTomcat is already running (pid: $pid)\e[00m\n"
    else
        # Start tomcat
        echo -e "\e[00;32mStarting tomcat\e[00m\n"
        $CATALINA_HOME/bin/startup.sh

        sleep 2
        let kwait=$STARTUP_WAIT
        count=0;
        until [ `grep -c 'Server startup in' $CATALINA_BASE/logs/catalina.out` = '1' ] || [ $count -gt $kwait ]
        do
            echo -n -e "\n\e[00;31mStarting DAP...\e[00m\n";
            sleep 1
            let count=$count+1;
        done
        if [ $count -gt $kwait ]; then
            echo -n -e "\n\e[00;31mTomcat hasn't started in $STARTUP_WAIT seconds\e[00m\n"
            return -1
        fi

        if [ `grep -c 'ERROR\|SEVERE' $CATALINA_BASE/logs/catalina.out` = '0' ]
            then
                echo -n -e "\n\e[00;31mDAP has started\e[00m\n"
            else 
                echo -n -e "\n\e[00;31mDAP has started with errors\e[00m\n"
                return -1    
        fi    

        status
    fi
    return 0
}
status(){
    pid=$(tomcat_pid)
    if [ -n "$pid" ]; then echo -e "\e[00;32mTomcat is running with pid: $pid\e[00m\n"
    else echo -e "\e[00;31mTomcat is not running\e[00m\n"
    fi
}

terminate() {
    echo -e "\e[00;31mTerminating Tomcat\e[00m"
    kill -9 $(tomcat_pid)
}

stop() {
    pid=$(tomcat_pid)
    if [ -n "$pid" ]
    then
        echo -e "\e[00;31mStoping Tomcat\e[00m"
        #/bin/su -p -s /bin/sh $TOMCAT_USER
        $CATALINA_HOME/bin/shutdown.sh
        let kwait=$SHUTDOWN_WAIT
        count=0;
        until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
        do
            echo -n -e "\n\e[00;31mwaiting for processes to exit\e[00m\n";
            sleep 1
            let count=$count+1;
        done
        if [ $count -gt $kwait ]; then
            echo -n -e "\n\e[00;31mkilling processes didn't stop after $SHUTDOWN_WAIT seconds\e[00m\n"
            terminate
        fi
    else
        echo -e "\e[00;31mTomcat is not running\e[00m\n"
    fi
    return 0
}

case $1 in
    start)
    start ;;
    stop)
    stop   ;;
    restart)
    stop
    start ;;
    status)
    status ;;
    kill)
    terminate ;;
    *)
    echo -e $TOMCAT_USAGE ;;
esac

exit 0