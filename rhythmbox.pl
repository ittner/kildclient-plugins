package rhythmbox;
#: Version: 0.0.1
#: Description: Rhythmobx - DBus - KildClient interface
#: Author: Alexandre Erwin Ittner

use Net::DBus;

our $chatcmd = "chat";
our $prefix = "[music] ";

$::world->alias('^\/music$', '/rhythmbox::sendtrack');
$::world->alias('^\/music *(.+)$', '/rhythmbox::sendtrack("$1")');

sub help {
    $::world->send("Sends information on music tracks to the MUD.\n",
        "Commands:\n\n",
        "  /music          - Sends the track using the command '$chatcmd'\n",
        "  /music command  - Sends the track using the given command\n",
        "\n");
}

sub sendtrack {
    my ($cmd) = @_;
    if (!defined($cmd)) { $cmd = $chatcmd; }
    
    my $bus = Net::DBus->session();
    my $rhy = $bus->get_service("org.gnome.Rhythmbox");
    my $player = $rhy->get_object("/org/gnome/Rhythmbox/Player", "org.gnome.Rhythmbox.Player");
    my $shell = $rhy->get_object("/org/gnome/Rhythmbox/Shell", "org.gnome.Rhythmbox.Shell");
    my $url = $player->getPlayingUri;
    my $songdata = $shell->getSongProperties($url);
    $::world->send($cmd . " " . $prefix . $songdata->{'artist'} . " - "
        . $songdata->{'album'} . " - " . $songdata->{'title'});
}


