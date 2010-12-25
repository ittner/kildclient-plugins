package vedit;
#: Version: 0.9.6
#: Description: Interface com o editor de texto do MUD Valinor
#: Author: Alexandre "dermeister" Erwin Ittner


# Configuração --------------------------------------------------------------

# Editor de texto. Ele lidar com texto na codificação UTF-8!
# Use 'notepad.exe' no Windows (mas salve o texto em utf-8, não 16).
our $editor = 'gedit';

# Limite de linhas a enviar por segundo. Use um valor saudável ou o MUD
# irá desconectá-lo por flood.
our $linespersec = 4;

# Número máximo de linhas permitidas por página de texto no editor do MUD.
our $maxlines = 48;

# Prefixo do arquivo temporário usado para edição.
# Use 'c:\windows\temp\vedit' no Windows.
our $tmpprefix = $ENV{'HOME'} . '/tmp/vedit';


# ---------------------------------------------------------------------------

use constant {
    IDLE                => 0,
    WAITING_RULER       => 1,
    WAITING_TEXT_START  => 2,
    WAITING_TEXT        => 3,
    EDITING_TEXT        => 4,
    SENDING_TEXT        => 5
};

our $state = IDLE;
our $text = undef;
our $fname = undef;

# ---------------------------------------------------------------------------

$::world->trigger(
    '^Editor de texto +/\? = ajuda /s = salvar /c = limpar /l = mostrar',
    '/vedit::handle_start', { name => 'vedit:editor' });

$::world->trigger('^-{70,}', '/vedit::handle_ruler',
    { name => 'vedit:editor' });

$::world->trigger('-{15,20}', '/vedit::handle_text_limits',
    { name => 'vedit:editor' });

$::world->trigger(' ?[0-9]+. (.*)', '/vedit::handle_text_feed($_[1])',
    { name => 'vedit:editor' });

$::world->trigger('O texto est. vazio\.', '/vedit::handle_empty',
    { name => 'vedit:editor' });

$::world->alias('^\/v$', '/vedit::send_text', { name => 'vedit:v' });

# ---------------------------------------------------------------------------

sub disable {
    $state = IDLE;
    $::world->distrigger('vedit:editor');
    $::world->disalias('vedit:v');
    $::world->echonl('vedit desabilitado.');
}

sub enable {
    $state = IDLE;
    $::world->enatrigger('vedit:editor');
    $::world->enaalias('vedit:v');
    $::world->echonl('vedit habilitado.');
}

sub UNLOAD {
    if($fname) { unlink($fname); }
}

sub help {
    $::world->send("Plugin para o editor de texto do MUD Valinor.");
}

sub tmpname {
    my $fname;
    while (1) {
        $fname = $tmpprefix . int(rand(10**7));
        unless (-f $fname) { return $fname };
    }
    return $fname;  # Inalcançável.
}

sub handle_start {
    if ($state == IDLE) {
        $state = WAITING_RULER;
    }
}

sub handle_ruler {
    if ($state == WAITING_RULER) {
        $::world->send('/l');
        $state = WAITING_TEXT_START;
    }
}

sub handle_text_limits {
    if ($state == WAITING_TEXT_START) {
        $text = "";
        $state = WAITING_TEXT;
    } elsif ($state == WAITING_TEXT) {
        $fname = tmpname();
        open(FD, ">$fname");
        # O MUD Valinor usa ISO-8859-1. Transforma em UTF-8.
        binmode(FD, ":utf8");
        print FD $text;
        print FD "/s <---- Mantenha esta linha intacta. ---->\n";
        close(FD);
        system("$editor $fname &");
        $text = undef;
        $::world->echonl("** Editando texto. Digite /v para recuperar. **");
        $state = EDITING_TEXT;
    }
}

sub handle_empty {
    if ($state == WAITING_TEXT_START) {
        $text = "";
        $state = WAITING_TEXT;
        handle_text_limits();
    }
}

sub handle_text_feed {
    my ($line) = @_;
    $text .= $line . "\n";
}

sub send_text {
    if ($state == EDITING_TEXT) {
        $state = SENDING_TEXT;
        $::world->send('/c');
        fix_empty_lines($fname);
        $::world->sendfile($fname, 1, $linespersec);
#        $::world->send('/s');
        unlink($fname);
        $fname = undef;
        $state = IDLE;  # There and back again ;)
    } else {
        $::world->echonl("** Não há nenhum texto carregado para enviar. **");
    }
}

# O KC não gosta de linhas em branco no arquivo. Trata o caso colocando
# um espaço quando necessário.

sub fix_empty_lines {
    my ($fname) = @_;
    my @lines;
    open(FD, $fname);
    while ($line = <FD>) {
        if ($line eq "\n") {
            push(@lines, " \n");
        } else {
            push(@lines, $line);
        }
    }
    close(FD);
    open(FD, ">$fname");
    foreach $line (@lines) {
        print FD ($line);
    }
    close(FD);
}
