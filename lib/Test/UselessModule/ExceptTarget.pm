package Test::UselessModule::ExceptTarget;
use strict;
use warnings;

use Data::Util;

my @except_target_module = ();

sub get{
    return @except_target_module;
}

sub add{
    my $add_list = shift;
    
    Data::Util::is_array_ref( $add_list ) or die;
    
    push @except_target_module , @{$add_list};

    return @except_target_module;
}

sub clear{
    @except_target_module = ();
}

1;
