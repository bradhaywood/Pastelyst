use strict;
use warnings;
use lib 'lib';
use Plack::Builder;
use Pastelyst;

builder {
    enable 'BufferedStreaming';
    Pastelyst->apply_default_middlewares(Pastelyst->psgi_app);
};

