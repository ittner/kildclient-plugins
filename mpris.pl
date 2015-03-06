package mpris;
#: Version: 0.0.1
#: Description: Read information from track being played in any music player
#: Author: Alexandre Erwin Ittner

use Net::DBus;
use strict;
use warnings;

our $chatcmd = "chat";
our $prefix = "[music] ";

$::world->alias('^\/music$', '/mpris::sendtrack');
$::world->alias('^\/music *(.+)$', '/mpris::sendtrack("$1")');

sub help {
    $::world->echo("Sends information on music tracks to the MUD.\n",
        "Commands:\n\n",
        "  /music          - Sends the track using the command '$chatcmd'\n",
        "  /music command  - Sends the track using the given command\n",
        "\n");
}


# Check if the owner of this bus name implements the MPRIS protocol, checks
# if is there a track playing and get any information available.

sub tryplayer {
    my ($bus, $bus_name) = @_;
    my $srv_bus = $bus->get_service($bus_name);
    if (!defined($srv_bus)) { return undef; }

    my $props = $srv_bus->get_object("/org/mpris/MediaPlayer2", "org.freedesktop.DBus.Properties");
    if (!defined($props)) { return undef; }

    my $st = $props->Get("org.mpris.MediaPlayer2.Player", "PlaybackStatus");
    if ($st eq 'Playing') {
        my $metadata = $props->Get("org.mpris.MediaPlayer2.Player", "Metadata");
        if (!defined($metadata)) { return undef; }
        my %metadata = %{$metadata};
        if (defined($metadata{'xesam:title'})) {
            my $track = '';
            if (defined($metadata{'xesam:artist'}) and defined($metadata{'xesam:artist'}[0])) {
                $track .= $metadata{'xesam:artist'}[0] . ' - ';
            }
            if (defined($metadata{'xesam:album'})) {
                $track .= $metadata{'xesam:album'} . ' - ';
            }
            $track .= $metadata{'xesam:title'};
            return $track;
        }
    }
    return undef;
}


sub sendtrack {
    my ($cmd) = @_;
    if (!defined($cmd)) { $cmd = $chatcmd; }

    my $bus = Net::DBus->session();

    my $dbus_srv = $bus->get_service("org.freedesktop.DBus");
    my $dbus_obj = $dbus_srv->get_object("/org/freedesktop/DBus", "org.freedesktop.DBus");
    my $running_services =  $dbus_obj->ListNames();

    my $track = undef;
    foreach my $tmp (@{$running_services}) {
        if ($tmp =~ /org\.mpris\.MediaPlayer2\..+/) {
            # A media player was found.
            my $track = tryplayer($bus, $tmp);
            if (defined($track)) {
                $::world->send($cmd . " " . $prefix . $track);
                return;
            }
        }
    }

    $::world->echonl("No music player is playing at the moment.");
}
