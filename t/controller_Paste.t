use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Pastelyst';
use Pastelyst::Controller::Paste;

ok( request('/paste')->is_success, 'Request should succeed' );
done_testing();
