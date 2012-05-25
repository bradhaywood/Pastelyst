package Pastelyst::View::HTML;

use strict;
use base 'Catalyst::View::TT::Alloy';

sub form_input {
    my ($c, $id, $label, $type) = @_;

    $type = 'text' if !$type;

    my ($required, $value, $error);
    if ($c->stash->{"$id\_required"}) {
        $error = "error";
        $required = "<span class=\"inline-helper\">This field is required</span>";
    }

    $value = $c->stash->{"$id\_value"} if $c->stash->{"$id\_value"};

    if ($type eq 'textarea') {
        return qq{
            <div class="control-group $error">
                <label class="control-label" for="$id">$label</label>
                <div class="controls">
                    <textarea class="input-large" id="$id" name="$id">$value</textarea>
                    $required
                </div>
            </div>
        };
    }
    else {
        return qq{
            <div class="control-group $error">
                <label class="control-label" for="$id">$label</label>
                <div class="controls">
                    <input type="$type" class="input-xlarge" id="$id" name="$id" value="$value">
                    $required
                </div>
            </div>
        };
    }
}

Template::Alloy->define_vmethod( 'text', form_input => \&form_input );

1;

