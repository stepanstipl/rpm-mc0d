#!/bin/sh
#
# mc0d ZeroMQ broker for MCollective
#
# chkconfig:   345 20 80 
# description: Puppetlab's implementation of ZeroMQ broker for Mcollective 

### BEGIN INIT INFO
# Provides: mc0d 
# Required-Start: $network
# Required-Stop: $network
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6 
# Short-Description: ZeroMQ broker for MColletive 
# Description: Puppetlab's implementation of simple ZeroMQ broker for 
#              Mcollective
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

APP='mc0d'
APP_DIR="/opt/${APP}"
ETC_DIR="/etc/${APP}"
BIN="${APP_DIR}/bin/${APP}"
KEY="${ETC_DIR}/private.key"
LOG_CFG="${ETC_DIR}/logger.config"

[ -e /etc/sysconfig/$APP ] && . /etc/sysconfig/$APP

lockfile=/var/lock/subsys/$APP

start() {
    [ -x $BIN ] || exit 5
    [ -f $KEY ] || exit 6
    [ -f $LOG_CFG ] || exit 6

    echo -n $"Starting ${APP}: "
    daemon $BIN
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $BIN
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
}

force_reload() {
    restart
}

rh_status() {
    # run checks to determine if the service is running or use generic status
    status $APP
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
