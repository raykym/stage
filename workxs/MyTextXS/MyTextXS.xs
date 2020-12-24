#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


MODULE = MyTextXS		PACKAGE = MyTextXS		

# 文字列のマッチングを試そうと思ったが、複雑過ぎてやめた
# 複数サブルーチンを試す

int increment2(value)
int value

    CODE:
       RETVAL = value + 2;

    OUTPUT:
       RETVAL

int increment3(value)
int value
 
    CODE:
        RETVAL = value + 3;

    OUTPUT:
        RETVAL

double sin(x)
double x

    CODE:
        RETVAL = sin(x);

    OUTPUT:
        RETVAL

