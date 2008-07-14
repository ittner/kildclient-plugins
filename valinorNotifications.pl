package valinorNotifications;
#: Version: 0.0.3
#: Description: Alertas de eventos do MUD Valinor
#: Author: Alexandre Erwin Ittner


our $defaultTimeout = 5000;
our $enabled = undef;
our $basedir = $ENV{HOME} . "/.kildclient/plugins";

# GPL icons copyrighted by the Pidgin project. 
our %msgIcons = (
    'login'   => "$basedir/log-in.png",
    'logout'  => "$basedir/log-out.png",
    'chat'    => "$basedir/chat.png",
    'tell'    => "$basedir/chat.png",
    'mtalk'   => "$basedir/chat.png"
);



BEGIN {
  $::world->requireplugin('notify');
}


$::world->hook('OnGetFocus', '/valinorNotifications::toggle(0)',
    { name => 'valinorNotifications:toggle' });

$::world->hook('OnLoseFocus', '/valinorNotifications::toggle(1)',
    { name => 'valinorNotifications:toggle' });

$::world->trigger('^\(OOC\) (.*telepaticamente.*)',
    '/valinorNotifications::message("tell", "Tell", $_[1])', 
    { name => 'valinorNotifications:tell', keepexecuting => 1 });

$::world->trigger('^\(OOC\) (.*)',
    '/valinorNotifications::message("chat", "Chat", $_[1])',
    { name => 'valinorNotifications:chat', keepexecuting => 1 });

$::world->trigger('^([A-Za-z]+[\)\>].*)',
    '/valinorNotifications::message("mtalk", "MTalk", $_[1])', 
    { name => 'valinorNotifications:mtalk', keepexecuting => 1 });

$::world->trigger('^Comm: ([A-Za-z]*)@([0-9.]+)\(.*has connected\.',
    '/valinorNotifications::message("login", "Conexão", "$_[1] conectou-se de $_[2]")', 
    { name => 'valinorNotifications:login', keepexecuting => 1 });

$::world->trigger('^Comm: ([A-Za-z]*)@([0-9.]+) has quit',
    '/valinorNotifications::message("logout", "Desconexão", "$_[1] saiu")', 
    { name => 'valinorNotifications:logout', keepexecuting => 1 });

sub help {
    $::world->echonl("Alertas para uma série de eventos do MUD Valinor.");
}

sub toggle {
    my ($status) = @_;
    if ($status == 1) {
        $enabled = 1;
        notify::msgFormatted('status', "MUD Valinor - Alertas ativados",
            "Eventos: <b>todos</b> (não há esse controle ainda)", 1500);
    } else {
        $enabled = undef;
    }
}

sub message {
    my ($event, $title, $text) = @_;
    if (defined($enabled)) {
        notify::msgSimple($event, "MUD Valinor - $title", $text,
            $defaultTimeout, $msgIcons{$event});
    }
}


