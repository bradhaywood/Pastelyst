#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Pastelyst';
all_from 'lib/Pastelyst.pm';

requires 'Plack::Builder';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Runtime' => '5.90011';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Restarter';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::View::TT::Alloy';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::View::JSON';
requires 'Digest::SHA';
requires 'DateTime';
requires 'Moose';
requires 'MooseX::NonMoose';
requires 'MooseX::MarkAsMethods';
requires 'DBD::SQLite';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
