use strict;
use warnings;

use Pastelyst;

my $app = Pastelyst->apply_default_middlewares(Pastelyst->psgi_app);
$app;

