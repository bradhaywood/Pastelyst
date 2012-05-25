package Pastelyst::Controller::Form;
use Digest::SHA 'sha512_base64';
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Pastelyst::Controller::Form - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Pastelyst::Controller::Form in Form.');
}

sub process :Action :Args(2) {
    my ($self, $c, $form, $args) = @_;

    my $errors = 0;
    my @errors = ();
    if ($c->req->body_params->{$form}) {
        map { $c->stash->{"$_\_value"} = $c->req->body_params->{$_} } keys %{$c->req->body_params};
        for (@{$args->{required}}) {
            if ($c->req->body_params->{$_} eq '') {
                $c->stash->{"$_\_required"} = 1;
                $errors++;
            }
        }

        # Does it have a model? If so, let's do stuff
        if ($args->{model}) {
            my $rs = $args->{model};
            if ($args->{check_if_exists}) {
                for (keys %{$args->{check_if_exists}}) {
                    if ($rs->find({ $_ => $args->{check_if_exists}->{$_} })) {
                        push @errors, "<li><strong>" . $args->{check_if_exists}->{$_} . "</strong> already exists</li>";
                        $c->stash->{"$_\_exists"} = 1;
                        $errors++;
                    }
                }
            }

        }

        if ($errors > 0) {
            if (@errors > 0) {
                unshift @errors, "<ul>";
                $errors[$#errors+1] = "</ul>";
                $c->stash->{error_msg} = join "\n", @errors;
            }
            $c->detach;
        }

        # Insert is true.. so let's insert this shit
        if ($args->{insert}) {
            my $fields = {};
            my $params = $c->req->body_params;
            foreach my $key (keys %$params) {
                unless ($key eq $form) {
                    if (grep { $_ eq $key } @{$args->{encrypt}}) {
                        $fields->{$key} = sha512_base64($params->{$key});
                    }
                    else {
                        $fields->{$key} = $params->{$key};
                    }
                }
            }
            my $created = $args->{model}->create($fields);
            $c->stash->{form_row} = $created if $created;
        }
        
        # Do we just want validation? Then validate this shit
        if ($args->{validate}) {
            my $row = $args->{model}->find($args->{validate});
            $c->stash->{form_row} = $row if $row;
        }

        $c->stash->{form_processed} = $form;
    }
}

=head1 AUTHOR

Brad Haywood

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
