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
        TheService::New::New
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
        TheService::New
        TheService::New::New
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
        TheService::New
        TheService::New::New
    /){
        ok ! Test::UselessModule::Finder::_is_subroutine($DATA , $class) , $class;
    }
    ok Test::UselessModule::Finder::_is_subroutine($DATA , 'TheService::Subroutine');
    ok Test::UselessModule::Finder::_is_subroutine($DATA , 'TheService::Constant');
};

subtest '_is_new' => sub{
    for my $ng_class (qw/
        TheService::Nothing
        TheService::Export
        TheService::Method
        TheService::MethodSpace
        TheService::MethodLF
        TheService::Parent
        TheService::New
    /){
        ok ! Test::UselessModule::Finder::_is_new($DATA , $ng_class) , $ng_class;
    }

    for my $ok_class (qw/
        TheService::New::New
    /){
        ok Test::UselessModule::Finder::_is_new($DATA , $ok_class) , $ok_class;
    }
};

subtest '_is_method_which_takes_module_name_in_the_first_parameter' => sub{
    for my $ng_class (qw/
        TheService::Nothing
        TheService::Subroutine
        TheService::Parent
        TheService::Export
        TheService::Constant
        TheService::Method
        TheService::MethodSpace
        TheService::MethodLF
        TheService::New
        TheService::New::New
        TheService::Faked
        TheService::Can
    /){
        ok ! Test::UselessModule::Finder::_is_method_which_takes_module_name_in_the_first_parameter(
            $DATA , $ng_class
        ), $ng_class;
    }
    for my $ok_class (qw/
        TheService::Can::Ok
        TheService::Faked::Module
    /){
        ok Test::UselessModule::Finder::_is_method_which_takes_module_name_in_the_first_parameter(
            $DATA , $ok_class
        ) ,$ok_class;
    }
};


subtest '_is_exist_import_sub' => sub{
    ok ! Test::UselessModule::Finder::_is_exist_import_sub(
        $DATA , []
    );
    ok ! Test::UselessModule::Finder::_is_exist_import_sub(
        $DATA , [qw/unexport/]
    );
    ok ! Test::UselessModule::Finder::_is_exist_import_sub(
        $DATA , [qw/unexport export_func/]
    );
    ok Test::UselessModule::Finder::_is_exist_import_sub(
        $DATA , [qw/unexport export_func export_and_use_func/]
    );
};

subtest '_is_pragma_module' => sub{
    for my $ok_class (
        'use 5.0008;',
        'use 5.0014;',
        'use strict;',
        'use warnings;',
        q{use constant HOGE => 'moge';},
        'use overload'
    ){
        ok Test::UselessModule::Finder::_is_pragma_module( $ok_class ), $ok_class;
    }
    for my $ng_class (
        'use TheService::Encodings qw/euc2utf8/;',
        'use TheService::Warnings;',
        q{use TheService::constant HOGE => 'moge';},
        'use TheService::overload'
    ){
        ok ! Test::UselessModule::Finder::_is_pragma_module( $ng_class ), $ng_class;
    }
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
use TheService::Export qw/ export_func export_and_use_func /;
use TheService::New;
use TheService::New::New;
use TheService::Faked::Module;
use TheService::Faked;
use TheService::Can;
use TheService::Can::Ok;

use Test::More;
use Test::MockObject;

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

    my $ret4 = export_and_use_func();

    my $ret5 = new TheService::New::New;

    my $mock1 = Test::MockObject->fake_module('TheService::Faked::Module', test => sub {1});
    can_ok("TheService::Can::Ok");

    return;
}

1;

