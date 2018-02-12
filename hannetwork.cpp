#include "hannetwork.h"
#include<QByteArray>
HanNetWork::HanNetWork()
{

    this->getUrl=new QString("http://apis.baidu.com/showapi_open_bus/pic/pic_search");
    this->apikey=new QString("eb1fade8792cbdeac566592bb6f48871");
    this->netmanager=new QNetworkAccessManager();
    connect(this->netmanager,SIGNAL(finished(QNetworkReply*)),this,SLOT(RecData(QNetworkReply*)));
}
HanNetWork::~HanNetWork()
{
    delete this->getUrl;
    delete this->apikey;
    delete this->netmanager;
}
//图片类型id,分页
void HanNetWork::getData(QString type, QString page)
{
    QString url=*(this->getUrl)+"?type="+type+"&page="+page;
    QNetworkRequest request;  //不能这样写(request())
    request.setUrl(url);
    //设置header键/值 (这里需要 qstring 转qbytearray ，方法是qstring->toutf8)
    request.setRawHeader("apikey",QByteArray(this->apikey->toUtf8()));
    this->netmanager->get(request);
}
void HanNetWork::RecData(QNetworkReply *reply)
{
    //发送信号
    emit this->qmlRecData(reply->readAll());
}
