package valinorNotifications;
#: Version: 0.0.1
#: Description: Alertas de eventos do MUD Valinor
#: Author: Alexandre Erwin Ittner


BEGIN {
  $::world->requireplugin('notify');
}

$::world->trigger('^\(OOC\) (.*)', '/notify::msgSimple("chat", "MUD Valinor - Chat", $_[1], 5000)',
    { name => 'valinorNotifications:chat' });

$::world->trigger('^([A-Za-z]+\>.*)', '/notify::msgSimple("mtalk", "MUD Valinor - MTalk", $_[1], 5000)', 
    { name => "valinorNotifications:mtalk" });

$::world->trigger('^\(OOC\) (.*telepaticamente.*)', '/notify::msgSimple("tell", "MUD Valinor - Tell", $_[1], 5000)', 
    { name => 'valinorNotifications:tell' });

$::world->trigger('^Comm: ([A-Za-z]*)@([0-9.]+) has connected.',
    '/notify::msgSimple("tell", "MUD Valinor - Conexão", "$_[1] conectou-se de $_[2]", 5000)', 
    { name => 'valinorNotifications:connection' });

$::world->trigger('^Comm: ([A-Za-z]*)@([0-9.]+) has quit.',
    '/notify::msgSimple("tell", "MUD Valinor - Desconexão", "$_[1] saiu", 5000)', 
    { name => 'valinorNotifications:connection' });

sub help {
    $::world->echonl("Alertas para uma série de eventos do MUD Valinor.");
}



