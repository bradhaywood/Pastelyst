use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Pastelyst';
use Pastelyst::Controller::Form;

ok( request('/form')->is_success, 'Request should succeed' );
done_testing();
