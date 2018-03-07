
use strict;
use utf8;
use feature 'say';
use Test::More;
use lib '../lib';
use bigint lib => 'GMP';
use Math::BigInt lib => 'GMP';

use Rsacrypt;

subtest 'encode method' => sub {

    my $str = << "EOF";
525271675252716952527171525271735252717552527176525271785252718052527182525271845252718652527188525271905252719852527110052527110252527110452527110752527110942525271111525271113525271114525271115525271116525271117525271435252714752527565525275665252756752527569525275715252757352527580525271755252758442
5252751075252791165252798052527976525279985252798952527973525279665252791135252797752527911452527912152527911852527511552527911152527547525279115525275575252796942525279785252797552527911252527910352527510952527510752527979525275113525275118525279107525279101525275120525279865252751225252751115252797142
8987741069071861099050104112971091161159887531189972701219951824910011010052101881116142
81857468826986718248104748310711677848553808570708385498286861081008987861116142
EOF

    my $n = Math::BigInt->new('29742357695967715654577134740023999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999993452720867370293649999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999998709');


    my $obj = Rsacrypt->new($str);
       $obj->pubkey($n);
       $obj->encode;

    my $res = $obj->encoderes;

    is ( $res, '25083789580440143872545551182583573710600894947845631525559740971910624494149823976619815621258196456345742726535828312353313243888345828554434157685793840847352551854732903384538895486240845961407643801100521577525666725647182999164332465318483944186415258494427666140873755817291774195746929082405922053442692208639484078320271850169502933376852894965399234900207334135552005282515669361211166196999095719059174653293114385207900976838933351104683689159065309260201701014369230441199958473007817857505904330278346041791079817410502010498173349173101492066637282457806523360413654687900884061202387796590085
15229417288592388396995907838803075154171499594626761614608256354284029912173485698074977171279094503479849797697777571618421191539656923662733850963456358241125155647989232648620024369490240133935067993741407026928739920045083472308624813743328230179814136486549678603917769301167513473438445954140560148685415340637878300618339766120519942371578619797011386273698215298111193955144885072351859601694417905449379672472808932768386208069850599740638346685062729980509990794975757913819927753169865676600906477501432664517074630948455549837912163885163365075326001428712238245508885644540014743205048835235807', 'code response');
};





subtest 'decode method' => sub {
    my $str = << "EOF";
25083789580440143872545551182583573710600894947845631525559740971910624494149823976619815621258196456345742726535828312353313243888345828554434157685793840847352551854732903384538895486240845961407643801100521577525666725647182999164332465318483944186415258494427666140873755817291774195746929082405922053442692208639484078320271850169502933376852894965399234900207334135552005282515669361211166196999095719059174653293114385207900976838933351104683689159065309260201701014369230441199958473007817857505904330278346041791079817410502010498173349173101492066637282457806523360413654687900884061202387796590085
15229417288592388396995907838803075154171499594626761614608256354284029912173485698074977171279094503479849797697777571618421191539656923662733850963456358241125155647989232648620024369490240133935067993741407026928739920045083472308624813743328230179814136486549678603917769301167513473438445954140560148685415340637878300618339766120519942371578619797011386273698215298111193955144885072351859601694417905449379672472808932768386208069850599740638346685062729980509990794975757913819927753169865676600906477501432664517074630948455549837912163885163365075326001428712238245508885644540014743205048835235807
EOF

    my $d = Math::BigInt->new('833223503208824418905406402225980194394006439110731342600363153638402734333277385293803500312800402825884614797747837099653630773456215572882493858431115247875246044219295970215298228481621069014449852754932328303095961060164487236217709080366815691899232494621358927018325526038726215725468056212520987520303147452724111509528968369012923997131391427743106947220653981720249629980011291331614202664143918702412377740818163785342630880266109220745533057662084013610632161984832995102003448433709202435265575171277293742466087858766803485054244167416879014907609441994598471092665212017638891008132810473473');

    my $n = Math::BigInt->new('29742357695967715654577134740023999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999993452720867370293649999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999998709'); 


    my $obj = Rsacrypt->new($str);
       $obj->privkey({d=>$d,n=>$n});
       $obj->decode;
    my $res = $obj->decoderes;

    is ( ref $res , 'ARRAY', 'decode response');

  #  say "res:";
  #  say for @$res;
  #  say "";

    my $string = join("\n",@$res);

    is $string, '525271675252716952527171525271735252717552527176525271785252718052527182525271845252718652527188525271905252719852527110052527110252527110452527110752527110942525271111525271113525271114525271115525271116525271117525271435252714752527565525275665252756752527569525275715252757352527580525271755252758442
5252751075252791165252798052527976525279985252798952527973525279665252791135252797752527911452527912152527911852527511552527911152527547525279115525275575252796942525279785252797552527911252527910352527510952527510752527979525275113525275118525279107525279101525275120525279865252751225252751115252797142
8987741069071861099050104112971091161159887531189972701219951824910011010052101881116142
81857468826986718248104748310711677848553808570708385498286861081008987861116142' , 'decode response';

};


done_testing;
