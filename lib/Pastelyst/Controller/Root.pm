package Pastelyst::Controller::Root;

use DateTime;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

=head1 NAME

Pastelyst::Controller::Root - Root Controller for Pastelyst

=head1 DESCRIPTION

This controller handles the default page (creating pastes) and retrieving pastes. Upon reaching the 'default' action (404) it will assume you're looking for a paste and try to find it for you. The template will do the rest.

=head1 METHODS

=head2 auto

Loads the sidebar, which holds the Recent pastes and karmatic ones. Karmatic are the snippets with the highest karma rating (the top 5). A snippet/paste can increase its karma by simply being visited.

=cut

sub auto :Private {
    my ($self, $c) = @_;

    if ($c->req->body_params->{'login-submit'}) {
        $c->forward( '/auth/login', [ $c->req->body_params ] );
    }

    my $paste_rs = $c->model('PasteDB::Paste');
    my $recent = $paste_rs->search(undef, {
        order_by => { -desc => 'paste_id' },
        rows => 10
    });

    my $karma = $paste_rs->search({
        karma => { '>', 0 }
    }, {
        rows => 5,
        order_by => { -desc => 'karma' }
    });

    if ($c->user) { $c->stash->{saved_pastes} = $c->user->saved_pastes; }
    $c->stash->{karma_pastes}  = [ $karma->all  ] if $karma->count > 0;
    $c->stash->{recent_pastes} = [ $recent->all ] if $recent->count > 0;
    $c->stash->{title} = $c->config->{name} . " - Add a snippet";
}

=head2 index

The main page. This is where a user can submit a new paste.

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{section} = 'home';
    if ($c->req->body_params->{submit}) {
        my $name   = $c->req->body_params->{name};
        my $syntax = $c->req->body_params->{syntax};
        my $code   = $c->req->body_params->{code};
        if ($name and $syntax and $code) {
            my $id;
            my @chars = ('a'..'z', '0'..'9', 'A'..'Z');
            $id .= $chars[rand($#chars)] for (0..8);
            my $uri = $c->req->uri . "${id}";
            my $dt  = DateTime->now;
            $c->model('PasteDB::Paste')->create({
                id           => $id,
                name         => $name,
                code         => $code,
                syntax       => $syntax,
                date_created => $dt->dmy('/') . ' ' . $dt->hms(':')
            });
            my $redirect_uri = "/${id}";
            $c->flash->{status_msg} = "Created new paste <strong>${uri}</strong>";
            $c->res->redirect($redirect_uri);
            $c->detach;
        }
        else {
            $c->flash->{last_code} = $code if $code;
            $c->flash->{error_msg} = "Please fill in <strong>all</strong> fields";
            $c->res->redirect($c->req->uri);
            $c->detach;
        }
    }
}

=head2 style

style simply changes the theme in the users session then redirects back to its referer page

=cut

sub style :Local :Args(1) {
    my ($self, $c, $style) = @_;
    $c->session->{style} = "light" if $style eq 'light';
    $c->session->{style} = "dark" if $style eq 'dark';
    $c->res->redirect($c->req->referer);
}

=head2 default

Catalyst uses default as its 404. Basically if you reach a page that doesn't exist, the "default" action will be called. Because we want urls to look like http://host/thisismyid, we will use default to look for the pastes and then load the paste.html template. If it finds a match it will set it in the stash.

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    my $id = $c->req->path;
    my $paste = $c->model('PasteDB::Paste')->find({ id => $id });
    if ($paste) {
        $c->stash->{title}    = $c->config->{name} . ' - ' . $paste->name;
        $c->stash->{paste}    = $paste;
    }
    else {
        $c->stash->{title} = $c->config->{name} . " - Why are we here?";
    }
    $c->stash->{template} = 'paste.html';
}

=head2 search

A simple case-insensitive search for the snippet name. This is just one of the many reasons I love DBIx::Class.

=cut

sub search :Local :Args(0) {
    my ($self, $c) = @_;
    
    if ($c->req->query_params->{q}) {
        my $query     = $c->req->query_params->{q};
        $query        = lc $query;
        my $result_rs = $c->model('PasteDB::Paste')->search({ 'LOWER(me.name)' => { like => "%${query}%" } });
        $c->stash->{results} = $result_rs if $result_rs->count > 0;
        $c->stash->{title}   = $c->config->{name} . " - Search results";
    }
}

=head2 search_autocomplete

=cut

sub search_autocomplete :Local :Args(1) {
    my ($self, $c, $q) = @_;

    my $paste_rs  = $c->model('PasteDB::Paste');
    my $results = $paste_rs->search_rs(
        \[ "lower(name) like ?", [dummy => lc "%$q%" ] ],
    );

    my @data;
    while(my $item = $results->next) {
        push @data, $item->name;
    }
    $c->stash->{json} = \@data;
    $c->detach('View::JSON');
}

sub pastes_json :Local :Args(0) {
    my ($self, $c) = @_;
    
    my @json;
    my $paste_rs = $c->model('PasteDB::Paste');
    while(my $p = $paste_rs->next) {
        push @json, $p->name;
    }

    $c->stash->{json} = \@json;
    $c->detach('View::JSON');
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Brad Haywood <brad@perlpowered.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
