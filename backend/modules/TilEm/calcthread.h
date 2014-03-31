#ifndef CALCTHREAD_H
#define CALCTHREAD_H

#include "calc.h"
#include "config.h"

#include <QThread>

/*!
    \class CalcThread
    \brief Utility class to manage calc emulation

    Perform the emulation in a separate thread to reduce latency in both GUI and emulator.
*/
class CalcThread : public QThread
{
    Q_OBJECT

    public:
        CalcThread(Calc *c, QObject * p = 0);

        void step();

        void stop();

    Q_SIGNALS:
        void runningChanged(bool y);

    protected:
        virtual void run();

    private:
        Calc *m_calc;
        volatile int exiting;
};

#endif // CALCTHREAD_H
