package Test::UselessModule::Finder;
use strict;
use warnings;

use List::MoreUtils;

my @CPAN_MODULE = qw/
    strict
    warnings
    constant
    utf8
    vars
    overload
    Mouse
    UNIVERSAL
    Readonly
    URI::QueryParam
/;

my @INHERITANCE_MODULE = qw/
    base
    parent
/;

my @THE_SERVICE_MODULE = qw/
    TheService;
    TheService::Core;
/;

# - mixed (Upper|Lower)Case-method
#   ( for example Date::Calc::Add_Delta_DHMS )
# - loading other NameSpace
#   ( for example Path::Class -> Path::Class::Dir & Path::Class::File )
my @ABNORMAL_MODULE = qw/
    Date::Calc
    YAML
    Path::Class
/;

sub namespace2path{
    my $target = shift;

    return 'lib/' unless defined $target;
    return $target if $target =~ qr{^lib/};

    return sprintf('lib/%s',
        join '/',split /::/,$target
    );
}

sub check_file {
    my ($check) = @_;

    open(my $read_file, '<', $check);
    my $file = do {
        local $/;
        <$read_file>;
    };
    close($file);

    open($read_file, '<', $check);
    my @use_module;
    for my $line ( <$read_file> ){
        chomp $line;
        
        next if _is_cpan_core_module($line);
        next if _is_inheritance_module($line);
        next if _is_the_service_module($line);
        
        my @values = ( $line =~ m/\Ause ([\w\:]+)([^;]*)?;\z/g );
        next if ! @values;

        my $itr = List::MoreUtils::natatime( 2, @values );
        my ( $package, $value ) = $itr->();
        my @func = _import_func2ary($value);
        push @use_module , { package =>  $package , func => \@func};
    }
    close($read_file);

    my @error = _check_using_module( $file , @use_module );

    return \@error;
}

sub _check_using_module{
    my ( $file , @use_module ) = @_;

    my @error;
    for my $module ( @use_module ){
        unless (
            _is_class_method( $file , $module->{package} ) 
        ||
            _is_subroutine( $file , $module->{package} )
        ){
            unless( scalar @{$module->{func}} ){
                push @error , $module->{package};
                next;
            }
            if( ! _is_exist_import_sub( $file , $module->{func} ) ){
                push @error , $module->{package};
                next;
            }
        }
    }
    return @error;
}

sub _is_cpan_core_module{
    my $line = shift;
    return 1 if _is_hit_module( $line , \@CPAN_MODULE );
}

sub _is_inheritance_module{
    my $line = shift;
    return 1 if _is_hit_module( $line , \@INHERITANCE_MODULE );
}

sub _is_the_service_module{
    my $line = shift;
    return 1 if _is_hit_module( $line , \@THE_SERVICE_MODULE );
}

sub _is_hit_module{
    my ( $line , $module ) = @_;

    my $regexp = join '|' , @{$module};
    return 1 if $line =~ /($regexp)/ ;
}

sub _import_func2ary{
    my $import_func = shift;

    my @ary = ( $import_func =~ m/[\w]+/g );
    shift @ary;

    return @ary;
}

sub _is_class_method{
    my ( $file , $module ) = @_;

    $file =~ qr/$module(\s|\n)*\-\>/;
}

sub _is_subroutine{
    my ( $file , $module ) = @_;

    while( $file =~ /$module\:\:([\w]+)/g ){

        # [TheService::Hoge::piyo] is seemed as function
        # [TheService::Hoge::FUGA] is seemed as constants
        if( $1 =~ /\A[_a-z0-9]+\z/ || $1 =~ /\A[_A-Z0-9]+\z/ ){
            return 1;
        }
        elsif( _is_hit_module($module , \@ABNORMAL_MODULE) ){
            return 1;
        }
    }
    return 0;
}

sub _is_exist_import_sub{
    my ( $file , $func_aryref ) = @_;

    for my $func ( @{$func_aryref} ){
        return 1 if $file =~ qr/$func/;
    }
    return 0;
}

1;

__END__

=head1 NAME

Test::UselessModule::Finder - finding useless module

=head1 SYNOPSIS

use Test::UselessModule::Finder;

=head1 DESCRIPTION

Test::UselessModule::Finder is

=head1 AUTHOR

masartz E<lt>masartz@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
