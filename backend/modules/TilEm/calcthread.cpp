#include "calcthread.h"

#include <QDebug>

CalcThread::CalcThread(Calc *c, QObject * p)
    : QThread(p), m_calc(c), exiting(0)
{

}
void CalcThread::step()
{
    if ( isRunning() )
        return;

    exiting = 1;
    start();
}

void CalcThread::stop()
{
//  top emulator thread before loading a new ROM
    exiting = 1;

//  wait for thread to terminate
    while ( isRunning() )
        usleep(1000);
}

void CalcThread::run()
{
    int res;

    qDebug() << "CalcThread: " << "start running";

    emit runningChanged(true);

    forever
    {
        if ( (res = (exiting ? m_calc->run_cc(1) : m_calc->run_us(10000))) )
        {
//          if ( res & TILEM_STOP_BREAKPOINT )
//          {
//              qDebug("breakpoint hit");
//          } else {
//              qDebug("stop:%i", res);
//          }
            break;
        }

        if ( exiting )
            break;

//      slightly slow down emulation (TODO : make delay adjustable)
        usleep(10000);
    }

    exiting = 0;

    qDebug() << "CalcThread: " << "stop running";

    emit runningChanged(false);
}
