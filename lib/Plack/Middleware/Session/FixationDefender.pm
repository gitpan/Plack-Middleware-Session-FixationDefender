package Plack::Middleware::Session::FixationDefender;
use warnings;
use strict;

use parent 'Plack::Middleware::Session';

our $VERSION = '0.04b';

sub commit {
    my($self, $env) = @_;

    my $session = $env->{'psgix.session'};
    my $options = $env->{'psgix.session.options'};

    if ($options->{expire}) {
        $self->store->remove($options->{id});
    } elsif ($options->{change_id}) {
        $self->store->remove($options->{id});
        $options->{id} = $self->generate_id($env);
        $self->store->store($options->{id}, $session);
    } else {
        $self->store->store($options->{id}, $session);
    }
}


1;
__END__

=head1 NAME

Plack::Middleware::Session::FixationDefender - Plack::Middleware::Session + fixation block


=head1 SYNOPSIS

    # app.psgi
    builder {
        enable 'Session::FixationDefender',
        $app;
    };

    # Login Action
    if ($self->auth) {
        # login OK
        $req->env->{'psgix.session.options'}->{'change_id'}++;
    } else {
        # login FAILED
        ...
    }

=head1 AUTHOR

Shinichiro Aska

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Shinichiro Aska C<< <s.aska.org@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
