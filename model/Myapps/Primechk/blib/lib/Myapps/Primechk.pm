package Myapps::Primechk;

use strict;
use warnings;
use utf8;
use feature 'say';

use FindBin;
use lib "$FindBin::Bin/..";   # Myappsまでまでを通す
use Myapps::Calcchange;

#use bigint lib => 'GMP';
use Math::BigInt lib => 'GMP';
use Math::GMP;

our $VERSION = '0.900';

# check機能そのものはGMPライブラリのprobab_prime関数と同じことをするが速度は遅い
# Primechk->new(#);
# Primechk->check;
# Primechk->result;  0: false, 1: true 

# Primechk->factor;
#         ->factorres;  ref @result
# Primechk->divisor;
#         ->divisorres; ref @result

# Primechk->new(A,B);
# Primechk->gcd;   #最大公約数　ユークリッド除算法
#         ->gcdres;
# $self->{gcdhistory} 履歴を取得する

# Primechk->axby1; # 履歴を利用して2元一次不等方程式を解く
# Primechk->equation; # 結果を文字列として得る。　　履歴から逆に展開して式を作る。 ax + by = 1の形式でx,yを求める

sub new {
    my ($class,@arg) = @_;

    my @bigarg = map { Math::BigInt->new("$_"); } @arg;

    return bless { 'string' => $bigarg[0], 'argarray' => \@bigarg } , $class;
}

sub string {
    my $self = shift;

    return $self->{string};
}

sub check {
    my $self = shift;

    my $num = $self->{string};

    # 6以下の処理
    if ( $num == 1 || $num == 2 || $num == 3 || $num == 5 ) {
        $self->{result} = 1; # true
        return;
    } elsif ( $num == 4 || $num == 6 ) {
        $self->{result} = 0; # false
        return;
    }
    
    # 事前確認  6n+1 or 6n+5を確認 それ以外は　0:falseを返す	
    #my $chk = $num % 6;
     my $copy_num = $num->copy();
     my $chk = $copy_num->bmod(6);

    if (($chk == 1) || ($chk == 5) ) {
        # 素数かどうかをチェックする
         for ( my $i=2; $i<$num-1; $i++){    # C形式の書式にしないとbigintでエラーになる
          #  my $res = $num % $i;
             my $copy_num = $num->copy();
            my $res = $copy_num->bmod($i);
            print "PROG: $i \r";    #結果をファイルに落とすには邪魔だけど、 大きな値ではあったほうが良い
            if ($res == 0) {
                $self->{result} = 0; # false
                return;
            }
        }
    say ""; # プログレス表示を終了で改行させる
    $self->{result} = 1; # true
    return;
    }
        $self->{result} = 0; # false
        return;
}

sub result {
    my $self = shift;

    if ( ! defined $self->{result} ) {
        return;
    }

    return $self->{result};
}

sub divisor {
	 my $self = shift;

    my $num = $self->{string};

    my @res;
    my $cnt = $num;

    while ( $cnt >= 1 ) {
        my $chk = $num % $cnt;
        if ( $chk == 0 ) {
            push(@res,$cnt);
        } 
        $cnt--;
    }  
    $self->{divisorres} = \@res;
    return;
}

sub divisorres {
    my $self = shift;

    if ( ! defined $self->{divisorres} ) {
        return;
    }

    return $self->{divisorres};
}

sub factor {
    my $self = shift;

    my $num = $self->{string};

    my @res;

    # $numは減りながらループする  小さい数で割っていく
    for (my $i=2; $i < $num; $i++){
#        print "PROG: $num \r";
        my $chk = 0;

        # $numが素数ならパスする     
        my $chk_num = Math::GMP->new($num);
        my $chk_prime = $chk_num->probab_prime(50);
        last if ( ($chk_prime == 1 )||($chk_prime == 2));

        while ( $chk == 0 ) {
      #      $chk = $num % $i;
          my $num_tmp = $num->copy();
             $num_tmp->bmod($i);
             $chk = $num_tmp;
      #      if ( $chk == 0 ) {
            if ($num_tmp->is_zero()) {
      #          $num = $num / $i;
                 $num->bdiv($i);   # 割り切れて整数のはず
                push(@res,$i);
            }
        } # while
        
    } # for
#    say "";  # PROGの更新
    push(@res,$num);
    push(@res,1);

    $self->{factorres} = \@res;

    return;
}

sub factorres {
    my $self = shift;

    if ( ! defined $self->{factorres} ) {
        return;
    }

    return $self->{factorres};
}

sub gcd {
    my $self = shift;
     # ユークリッド互解法
     # 最大公約数
     # axby1で利用するgcdhistoryも作成

    my $argv = $self->{argarray};
    my @arg = @$argv;
    my $g;
    my $l;

    if ( $arg[0] < $arg[1] ) {
         $g = $arg[1];
         $l = $arg[0];
    } else {
         $g = $arg[0];
         $l = $arg[1];
    }

    my @history; 
    my $ans;
    while ( $l > 0 ) {
      #  my $tmp_l = $g % $l;   # 余り
        my $tmp_l = Math::BigInt->new("$g");   # 余り
           $tmp_l->bmod($l);

      #  my $div = $g / $l;  # 商
      #     $div = int($div);
        my $div = Math::BigInt->new("$g");
           $div->bdiv($l);
           $div->bint();   # 商のみが必要

        my $conte = { 'first' => $g , 'second' => $l , 'mod' => $tmp_l , 'div' => $div };
           push(@history,$conte);

        if ( $tmp_l == 0 ) {
           $ans = $l;
        }
           # 置き換え
           $g = $l;
           $l = $tmp_l;  # 最終的に0が入ってループを抜ける
    }

   $self->{gcdres} = $ans; 
   $self->{gcdhistory} = \@history;
}

sub gcdres {
    my $self = shift;

    if ( ! defined $self->{gcdres} ) {
        return;
    }

    return $self->{gcdres};
}

sub gcdhistory {
    my $self = shift;

    if ( ! defined $self->{gcdhistory} ) {
        return;
    }

    return $self->{gcdhistory};
}

sub axby1 {
    my $self = shift;
    # ax + by =1 a,bが互いに素の場合のx,y
    # gcdでhistoryを作成している事が前提

    if ( ! defined $self->{gcdhistory} ){
        return;
    }

    my $tmp = $self->{gcdhistory};
    my @history = @$tmp;

    # mod = 0 (末尾）の履歴を削除する
      pop(@history);

 #   say "history -----";
 #   map { say "$_->{first} $_->{second} $_->{div} $_->{mod}"; } @history;
 #   say "-----";

    # テキスト置き換えで展開を行う
    # gcdのhistoryからmod = first * 1 - second * div　の書式に変更
    # mod をキーとして、2次元配列に  ( mod , text ) の構造
    my @mod_trans;
    for my $i (@history){
        my $text = "( $i->{first} * 1 - $i->{second} * $i->{div} )";   #  x * 1 - y * 商  形式に並べる
        my @label = ( $i->{mod} , $text );                             # 余りをキーとして配列にする
        push(@mod_trans, \@label);
    }

 #   say "mod_trans --------";
 #   map { my @a = @$_; say "$a[0] \t $a[1]" ; } @mod_trans;
 #   say "--------";

   my @mod_trans_r = reverse(@mod_trans);  #　逆順に処理するため

   my $context;    # text
   for my $i (@mod_trans_r){   # $iは　( mod , 式　) 形式の配列リファレンス
      my @mod = @$i;
    
      if ( ! defined $context) {
          $context = $mod[1];        # 初回のみ
       #   say "context: $context";
          next;
      }  

       my @pase = split / /,$context;  # 書式を配列に分解 数字、記号を個別にする
       my @pase_c;
       for (my $i = 0; $i <= $#pase; $i++ ){
          if (( $pase[$i] eq '*') || ( $pase[$i] eq '(') || ( $pase[$i] eq ')' ) || ( $pase[$i] eq '*' ) || ( $pase[$i] eq '/' ) || ( $pase[$i] eq '+' ) || ( $pase[$i] eq '-' ) ){
              push(@pase_c,$pase[$i]);  # 記号はここで
              next;
          }
          # 書式の数値と余りが一致した時に、数字の後ろが *印なら、数字を書式で置き換える
          if (( $pase[$i] == $mod[0] ) && ( $pase[$i+1] eq '*') ){       # 文字列だと多重パッチする。 数字の重複は'*'の前のみ
              push(@pase_c,$mod[1]);                                     # 数字を履歴(@mod_trans)の式に置き換える    
              next;
          } 
          push(@pase_c,$pase[$i]);  # 記号でなく、置き換え対象でない数値は、ここで追加される
       } # for @pase
       $context = join(" ",@pase_c);

       # modが一致するテキストに式を置き換え
    #      $context =~ s/$mod[0]/$mod[1]/g;    # 余りが一桁だと多重マッチしてしまう。上のforループが同じことをしようとしている
       #   say "before: $context";

          my $calchan = Myapps::Calcchange->new($context);
             $calchan->calcchange;

             $context = $calchan->calcchangeres;

       #   say "after: $context";
          undef $calchan;
   } # for mod_trans_r

   $self->{indefinite_equation} = $context;
}

sub  equation {
    my $self = shift;

    if ( ! defined $self->{indefinite_equation} ) {
        return;
    }

    return $self->{indefinite_equation};
}

1;

