package Pastelyst::Controller::Paste;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Pastelyst::Controller::Paste - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller for some paste methods.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Pastelyst::Controller::Paste in Paste.');
}

=head2 paste_chain

Sets the paste ID in the stash or redirects you to the default page

=cut

sub paste_chain :Chained('/') :PathPart('paste') :CaptureArgs(1){
    my ($self, $c, $id) = @_;
    my $paste = $c->model('PasteDB::Paste')->find({ id => $id });
    unless ($paste) {
        $c->detach('/default');
    }
    
    $c->stash->{paste} = $paste;
}

sub save :Chained('paste_chain') :PathPart('save') {
    my ($self, $c) = @_;
    my $paste = $c->stash->{paste};
    my $save_rs = $c->model('PasteDB::SavedPaste');
    if ($c->user->saved_pastes->find({ paste_id => $paste->id })) {
        $c->flash->{error_msg} = "You have already saved <strong>" . $paste->name . "</strong>";
        $c->res->redirect($c->req->base . $paste->id);
        $c->detach;
    }
    $save_rs->create({
        user_id  => $c->user->id,
        paste_id => $paste->id
    });
    
    $c->flash->{status_msg} = "Saved <strong>" . $paste->name . "</strong> to your favorites";
    $c->res->redirect($c->req->base . $paste->id);
    $c->detach;
}

sub add_karma :Chained('paste_chain') :PathPart('karmanize') {
    my ($self, $c) = @_;
    my $paste = $c->stash->{paste};
    # this will eventually be for logged in users only
    $paste->update({ karma => ($paste->karma + 1) });
    $c->flash->{info_msg} = "Added +1 karma to <strong>" . $paste->name . "</strong>";
    $c->res->redirect($c->req->base . $paste->id);
    $c->detach;
}

=head2 delete

Removes the paste loaded in the stash and then redirects you back to the front page in the Root controller

=cut

sub delete :Chained('paste_chain') :PathPart('delete') {
    my ($self, $c) = @_;
    my $paste      = $c->stash->{paste};
    my $id         = $paste->id;
    $paste->delete;
    $c->flash->{status_msg} = "Removed paste <strong>${id}</strong>";
    $c->res->redirect($c->uri_for($c->controller('Root')->action_for('index')));
    $c->detach;
}

=head1 AUTHOR

Brad Haywood <brad@perlpowered.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
