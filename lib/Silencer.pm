package Std::Silencer;
use 5.16.1;
use strict;
use warnings;

use File::Spec;

sub on {
    no strict 'refs';
    my @sv = map {
        open my $fh, q[>&] . $_;
        open \*{$_}, File::Spec->devnull();
        $fh
    } qw/STDOUT STDERR/;
    bless \@sv => ref($_[0]) || $_[0]
}

sub off {
    my $self = $_[0];
    open $_ ? *STDERR : *STDOUT, q[>&], $self->[$_] for 0, 1;
    @{$self} = ()
}

sub DESTROY {
    my $self = $_[0];
    $self->off if @{$self};
}

1;
