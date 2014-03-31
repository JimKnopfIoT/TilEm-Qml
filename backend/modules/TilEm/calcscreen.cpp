#include "calcscreen.h"

#include <QThread>
#include <QPainter>
#include <QDebug>

#include "calc.h"

CalcScreen::CalcScreen(QQuickItem *parent) :
    QQuickPaintedItem(parent), m_calc(NULL)
{
//    setFillColor(Qt::color1);
    connect(this, SIGNAL( widthChanged() ), this, SLOT( setLcd() ));
    connect(this, SIGNAL( heightChanged() ), this, SLOT( setLcd() ));
}

CalcScreen::~CalcScreen()
{
}

void CalcScreen::paint(QPainter *painter)
{
    QRectF target = contentsBoundingRect();
    QRectF source(0.0, 0.0, m_lcdW, m_lcdH);
    painter->drawImage(target,m_screen,source);
}

Calc *CalcScreen::calc() const
{
    return m_calc;
}

void CalcScreen::setLcd()
{
    if(m_lcdW == (int)width() && m_lcdH == (int)height())
        return;
    m_lcdW = (int)width();
    m_lcdH = (int)height();
    qDebug() << "setLcd: " << m_lcdW << "x" << m_lcdH;
    m_screen = QImage(m_lcdW,m_lcdH, QImage::Format_RGB32);
    updateLCD();
}

void CalcScreen::fileLoaded()
{
    qDebug() << "fileLoaded";
    // start LCD update timer
    m_lcdTimerId = startTimer(10);
}

void CalcScreen::beforeFileLoaded()
{
    killTimer(m_lcdTimerId);
}

void CalcScreen::timerEvent(QTimerEvent *e)
{
    if ( e->timerId() == m_lcdTimerId )
        updateLCD();
    else
        QQuickPaintedItem::timerEvent(e);
}

void CalcScreen::setCalc(Calc *arg)
{
    if (m_calc != arg) {
        delete m_calc;
        m_calc = arg;
        connect(m_calc, SIGNAL(loaded()), this, SLOT( fileLoaded() ));
        connect(m_calc, SIGNAL(beginLoad()), this, SLOT( beforeFileLoaded() ));
        emit calcChanged(arg);
    }
}

void CalcScreen::takeScreenshot()
{

}

void CalcScreen::updateLCD()
{
    if( m_calc->lcdUpdate()) {
        const int w = m_calc->lcdWidth();
        const int h = m_calc->lcdHeight();

        QRgb *d = reinterpret_cast<QRgb*>(m_screen.bits());
        const unsigned int *cd = m_calc->lcdData();

        // write LCD into skin image
        for ( int i = 0; i < m_lcdH; ++i )
        {
            for ( int j = 0; j < m_lcdW; ++j )
            {
                int y = (h * i) / m_lcdH;
                int x = (w * j) / m_lcdW;

                d[i * m_lcdW + j] = cd[y * w + x];
            }
        }
        update(boundingRect().toAlignedRect());
    }
    else if(!m_calc->isValid() ) {
        m_screen.fill(Qt::transparent);
    }
}
