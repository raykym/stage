#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


MODULE = Myapps::MySubsXS		PACKAGE = Myapps::MySubsXS		

# 引数value配列を自乗して返す関数
SV*
increment2(value)
SV* value
CODE:
    AV* nums_av = (AV*)SvRV(value);
    size_t nums_len = av_len(nums_av);
    AV* ret_nums = (AV*)sv_2mortal((SV*)newAV());
    for (int i = 0; i <= nums_len; i++) {
        SV** num_sv_ptr = av_fetch(nums_av, i, FALSE);
        SV* num_sv = num_sv_ptr ? *num_sv_ptr : &PL_sv_undef;
        IV num = SvIV(num_sv);
        num = num * num;
        av_push(ret_nums , SvREFCNT_inc(sv_2mortal(newSViv(num))));
    }
    SV* nums_avrv = sv_2mortal(newRV_inc((SV*)ret_nums));
    RETVAL = nums_avrv;
OUTPUT:
    RETVAL

# geoDirectionサブルーチン
int
geoDirection(lat1,lng1,lat2,lng2)
double lat1
double lng1
double lat2
double lng2
    CODE:
    #   緯度経度 lat1, lng1 の点を出発として、緯度経度 lat2, lng2 への方位
    # 北を０度で右回りの角度０～３６０度
    double Y = cos(lng2 * M_PI / 180) * sin(lat2 * M_PI / 180 - lat1 * M_PI / 180);
    double X = cos(lng1 * M_PI / 180) * sin(lng2 * M_PI / 180) - sin(lng1 * M_PI / 180) * cos(lng2 * M_PI / 180) * cos(lat2 * M_PI / 180 - lat1 * M_PI / 180);
    # 東向きが０度の方向
    int dirE0 = 180 * atan2(Y, X) / M_PI;
    if (dirE0 < 0) {
        #0～360 にする。
        dirE0 = dirE0 + 360;
    }
    #(dirE0+90)÷360の余りを出力 北向きが０度の方向
    int dirN0 = (dirE0 + 90) % 360;
    RETVAL = dirN0;
    OUTPUT:
    RETVAL



