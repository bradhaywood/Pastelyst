use utf8;
package Pastelyst::Schema::Result::Paste;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Pastelyst::Schema::Result::Paste

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<pastes>

=cut

__PACKAGE__->table("pastes");

=head1 ACCESSORS

=head2 paste_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 code

  data_type: 'blob'
  is_nullable: 0

=head2 syntax

  data_type: 'text'
  is_nullable: 0

=head2 date_created

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "paste_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "karma",
  { data_type => "integer", is_nullable => 1 },
  "code",
  { data_type => "blob", is_nullable => 0 },
  "syntax",
  { data_type => "text", is_nullable => 0 },
  "date_created",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</paste_id>

=back

=cut

__PACKAGE__->set_primary_key("paste_id");


# Created by DBIx::Class::Schema::Loader v0.07022 @ 2012-04-17 00:07:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OShLX6ZMhUSMwH8pZ5vROw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
