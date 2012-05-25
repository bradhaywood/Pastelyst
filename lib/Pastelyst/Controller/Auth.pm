package Pastelyst::Controller::Auth;
use Moose;
use namespace::autoclean;

use Digest::SHA 'sha512_base64';

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Pastelyst::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Pastelyst::Controller::Auth in Auth.');
}

sub signup :Local :Args(0) {
    my ($self, $c) = @_;

    my $form_args = {
        required => [ qw<username password name> ],
        encrypt   => [ 'password' ],
        model    => $c->model('PasteDB::User'),
        check_if_exists => { username => $c->req->body_params->{username} },
        encrpyt  => 'password',
        insert   => 1
    };

    $c->forward('/form/process', [ 'create-user', $form_args ]);

    if ($c->stash->{form_row}) {
        $c->flash->{status_msg} = "Thanks for joining! You can now login";
        $c->res->redirect('/');
        $c->detach;
    }
}

sub login :Action :Args(1) {
    my ($self, $c, $params) = @_;

    if ($c->authenticate({
            username => $params->{'login-username'},
            password => sha512_base64($params->{'login-password'})
    })) {
            $c->res->redirect($c->req->uri);
            $c->detach;
    }
    else {
        $c->flash->{error_msg} = "Incorrect email address/password";
        $c->res->redirect($c->req->uri);
        $c->detach;
    }
}

sub logout :Local :Args(0) {
    my ($self, $c) = @_;
    $c->logout;
    $c->res->redirect('/');
    $c->detach;
}

=head1 AUTHOR

Brad Haywood

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
