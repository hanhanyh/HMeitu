#ifndef HANNETWORK_H
#define HANNETWORK_H

#include <QObject>
#include<QString>
#include<QUrl>
#include<QtNetwork/qnetworkaccessmanager.h>
#include<QtNetwork/qnetworkrequest.h>
#include<QtNetwork/qnetworkreply.h>
#include<QUrl>
class HanNetWork:public QObject
{
    Q_OBJECT
private:
    QString * getUrl;
    QString * apikey;
    QNetworkAccessManager * netmanager;
public:
    HanNetWork();
    //INVOKABLE 暴露给qml
    Q_INVOKABLE void getData(QString type,QString page);
    ~HanNetWork();
 signals:
    //qml层面 （返回给qml数据(json)）
    void qmlRecData(QString data);
public slots:
    void RecData(QNetworkReply * reply);

};

#endif // HANNETWORK_H
