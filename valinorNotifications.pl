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
    

sub help {
    $::world->echonl("Alertas para uma série de eventos do MUD Valinor.");
}

