package dermalert;
#: Version: 0.0.1
#: Description: Despertador para o Dermeister
#: Author: Alexandre Erwin Ittner


our $defaultTimeout = 5000;
our $enabled = undef;

BEGIN {
  $::world->requireplugin('notify');
}


$::world->hook('OnGetFocus', '/dermalert::toggle(0)',
    { name => 'dermalert:toggle' });

$::world->hook('OnLoseFocus', '/dermalert::toggle(1)',
    { name => 'dermalert:toggle' });

$::world->trigger('^(.*derm.*)$',
    '/dermalert::message("tell", "MUD chamando Dermeister!", $_[1])', 
    { name => 'dermalert:alert', ignorecase => 1, keepexecuting => 1 });


sub help {
    $::world->echonl("Despertador para outras atividades");
}

sub toggle {
    my ($status) = @_;
    if ($status == 1) {
        $enabled = 1;
        notify::msgSimple('status', "MUD Valinor", "Dermalert ativado!", 1500);
    } else {
        $enabled = undef;
    }
}

sub message {
    my ($event, $title, $text) = @_;
    if (defined($enabled)) {
        notify::msgSimple($event, $title, $text, $defaultTimeout);
    }
}

