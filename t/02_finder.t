use strict;
use warnings;

use Test::More;
use Test::UselessModule::Finder;

my $DATA;
{
    local $/;
    $DATA = <DATA>;
}

subtest '_import_func2ary' => sub{
    my $str = 'qw/foo bar baz/';
    my @ary = Test::UselessModule::Finder::_import_func2ary( $str );
    is_deeply \@ary , [qw/foo bar baz/];
};

subtest '_is_hit_module' => sub{
    my @classes = qw/
        TheService::Nothing
        TheService::Subroutine
        TheService::Export
    /;
    for my $class ( @classes ){
        ok Test::UselessModule::Finder::_is_hit_module($class , \@classes);
    }
    ok ! Test::UselessModule::Finder::_is_hit_module('TheService::Other' , \@classes);
};

subtest '_is_class_method' => sub{
    for my $ng_class (qw/
        TheService::Nothing
        TheService::Subroutine
        TheService::Parent
        TheService::Export
        TheService::Constant
    /){
        ok ! Test::UselessModule::Finder::_is_class_method(
            $DATA , $ng_class
        ), $ng_class;
    }
    for my $ok_class (qw/
        TheService::Method
        TheService::MethodSpace
        TheService::MethodLF
    /){
        ok Test::UselessModule::Finder::_is_class_method(
            $DATA , $ok_class
        ) ,$ok_class;
    }
};

subtest '_is_subroutine' => sub{
    for my $class (qw/
        TheService::Nothing
        TheService::Export
        TheService::Method
        TheService::MethodSpace
        TheService::MethodLF
        TheService::Parent
    /){
        ok ! Test::UselessModule::Finder::_is_subroutine($DATA , $class) , $class;
    }
    ok Test::UselessModule::Finder::_is_subroutine($DATA , 'TheService::Subroutine');
    ok Test::UselessModule::Finder::_is_subroutine($DATA , 'TheService::Constant');
};

subtest '_is_exist_import_sub' => sub{
    ok ! Test::UselessModule::Finder::_is_exist_import_sub(
        $DATA , []
    );
    ok ! Test::UselessModule::Finder::_is_exist_import_sub(
        $DATA , [qw/unexport/]
    );
    ok Test::UselessModule::Finder::_is_exist_import_sub(
        $DATA , [qw/unexport export_func/]
    );
};

done_testing;

__DATA__

package TheService::Sample;
use strict;
use warnings;

use TheService::Nothing;
use TheService::Subroutine;
use TheService::Subroutine::Inner;
use TheService::Constant;
use TheService::Constant::Inner;
use TheService::Parent::Child;
use TheService::Method;
use TheService::MethodSpace;
use TheService::MethodLF;
use TheService::Export qw/ export_func /;

sub new{
    my ( $class , %args ) = @_;
    my $self = { %args };
    return bless $sel , $class;
}

sub display{
    my $self = shift;

    my $ret11 = TheService::Method->some_method();
    my $ret12 = TheService::MethodSpace  ->some_method();
    my $ret13 = TheService::MethodLF
        ->some_method();

    my $ret2 = TheService::Subroutine::some_function();

    my $ret3 = TheService::Constant::CONSTANT_CASE;

    my $ret4 = export_func();

    return;
}

1;

