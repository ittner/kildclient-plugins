package notify;
#: Version: 0.0.1
#: Description: Notify - Sends session notification messages from the MUD
#: Author: Alexandre Erwin Ittner

use Net::DBus;

our $defIcon = "/usr/share/pixmaps/kildclient.png";
our %ourMsgIds;

sub help {
    $::world->echonl("Sends session notification messages from the MUD.\n",
        "To send a new message, call:",
        "   notify::msgSimple(msg_name, msg_title, msg_text, timeout)",
        "   notify::msgFormatted(msg_name, msg_title, msg_text, timeout)",
        "   notify::msgSimple(msg_name, msg_title, msg_text, timeout, icon)",
        "   notify::msgFormatted(msg_name, msg_title, msg_text, timeout, icon)",
        "of course, this works better when called from a trigger.",
        "\n");
}


sub msgFormatted {
    my ($name, $title, $text, $timeout, $icon) = @_;

    if (defined($ourMsgIds{$name})) {
        $id = $ourMsgIds{$name};
    } else {
        $id = 0;
    }

    if (!defined($icon)) {
        $icon = $defIcon;
    }
    my $bus = Net::DBus->session();
    my $service = $bus->get_service("org.freedesktop.Notifications");
    my $notify = $service->get_object("/org/freedesktop/Notifications",
        "org.freedesktop.Notifications");

    $ourMsgIds{$name} = $notify->Notify("kildclient", $id, $icon, $title,
        $text,  [], { }, $timeout);
}


sub msgSimple {
    my ($name, $title, $text, $timeout, $icon) = @_;
    
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    
    msgFormatted($name, $title, $text, $timeout, $icon);
}


