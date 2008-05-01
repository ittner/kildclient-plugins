package valinorwho;
#: Version: 0.1
#: Description: WHO Window para o MUD Valinor
#: Author: Alexandre Erwin Ittner

use Gtk2 -init;
use Gtk2::GladeXML;

our $gladexml;
our $wnWho;
our @whoList;

$::world->alias('^vwho$', '/valinorwho::run()', { name => 'valinorwho:run' });

$::world->trigger('.*wholist;', '', { name => 'valinorwho:trgs', gag => 1 });

$::world->trigger('"([0-9]*)", *"([A-Za-z]*)", *"([A-Za-z]*)", *"([A-Za-z ]+)", *"([^"]*)", *"([^"]*)";',
        '/valinorwho::addWho($_[1], $_[2], $_[3], $_[4], $_[5], $_[6])',
        { name => 'valinorwho:trgs', gag => 1 });

$::world->trigger('endlist;', '/valinorwho::endWho()',
        { name => 'valinorwho:trgs', gag => 1 });


sub help 
{
    $::world->echonl('Este plugin exibe uma janela separada com uma lista '
        . 'de todos os personagens conectados ao MUD. Com o plugin '
        . 'carregado, digite VWHO para iniciar.');
}


sub findxml
{
    my $glade = 'valinorwho.glade';
    my $tmp = $ENV{'HOME'} . '/.kildclient/plugins/' . $glade;
    if (-e $tmp)
    {
        return $tmp;
    }
    foreach $tmp (@PLUGINDIRS)
    {
        if (-e "$tmp/$glade")
        {
            return "$tmp/$glade";
        }
    }
    return $glade;
}

sub on_btQuit_clicked
{
    my($name, $widget, $signal, $sigdata, $connect, $after, $udata) = @_;
    $wnWho->destroy;
}


sub startWho
{
    @whoList = ();
    $::world->enatrigger('valinorwho:trgs');
    $::world->send('WHO !cvalinor');
}


sub addWho
{
    $::world->echonl($_[4]);
    push(@whoList, { level => $_[1], race => $_[2], class => $_[3],
            name => $_[4], title => $_[5], rank => $_[6] });
}


sub endWho
{
    my $tmp;
    $::world->distrigger('valinorwho:trgs');
    foreach $tmp (@whoList)
    {
        $::world->echonl($tmp{'name'});
    }
}


sub run
{
    $gladexml = Gtk2::GladeXML->new(findxml());
    if(!$gladexml)
    {
        $::world->echonl('Erro ao iniciar interface.');
        return;
    }
    startWho();
#    $gladexml->signal_autoconnect_from_package('valinorwho', 'wnWho');
#    $wnWho = $gladexml->get_widget('wnWho');
#    $tvWho = $gladexml->get_widget('tvWho');
}


