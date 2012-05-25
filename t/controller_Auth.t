use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Pastelyst';
use Pastelyst::Controller::Auth;

ok( request('/auth')->is_success, 'Request should succeed' );
done_testing();
