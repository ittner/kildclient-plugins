package espeak;
#: Version: 0.2.4
#: Description: Interface para o sintetizador "espeak".
#: Author: Alexandre "dermeister" Erwin Ittner
#-*- coding: utf-8 -*-


# Configuração --------------------------------------------------------------

# Caminho para o eSpeak. Mude conforme seu sistema.
our $speakcmd = "/home/dermeister/espeak/speak -v pt";

#TO DO: Ajustes de volume, SSML, etc.


# ---------------------------------------------------------------------------

our %subtbl = (
    # Tabela de substituição de termos especiais para o MUD. Isso deveria
    # ficar em outro arquivo.

    # O índice do hash contém o termo (em minúsculas) e valor contém
    # a pronúcia, em um português que o eSpeak entenda ou segundo o alfabeto
    # fonético internacional (IPA). Se a pronúncia for fonética, coloque a
    # representação em IPA em ASCII -- detalhes em
    # http://www.kirshenbaum.net/IPA/ascii-ipa.pdf

    # Outra possibilidade é usar o eSpeak em linha de comando, com a opção
    # "-x" para descobrir os melhores fonemas para cada palavra.

    # Favor enviar contribuições para o dermeister (aittner@netuno.com) para
    # adição nas futuras versões do plugin.


    # Personagens do MUD. 
    "anneth"      => "[[&~n'Ef]]",
    "anor"        => "[['anor]]",
    "celebeth"    => "[[k'eleb,ef]]",
    "cild"        => "[[k'i;ld]]",
    "cildraemoth" => "[[k'i;ldrEmoT]]",
    "craygs"      => "[[k\@-*'eigs]]",
    "derinthuck"  => "[[d'erint,uk]]",
    "derm"        => "[[dEr m'aist%ar]]",
    "dermeister"  => "[[dEr m'aist%ar]]",
    "eleuvis"     => "[[el'Euvis]]",
    "gilgamesh"   => "[[Z,iUg&m'eS]]",
    "lebeault"    => "[[l,ebe'out]]",
    "leoric"      => "[[le'O*ik]]",
    "lionheart"   => "[[l'aIoN x'&rt]]",
    "quarion"     => "[[kw'a*i;oN]]",
    "setzer"      => "[[s'Etzer]]",
    "sparrow"     => "[[sp'ErOw]]",    
    "storm"       => "[[st'Orm]]",
    "tyreal"      => "[[t'aI*EU]]",
    "[uü]belgarten" => "[[_!'y:b\@lg,art\@n]]",
    "von"         => "fon",
    "zeferus"     => "[[z'Efe*us]]",
    "zeug"        => "[[z'eug]]",
    #"" => "[[]]",

    # Mudismos e termos informáticos.
    "MUD"         => "mud",         # Força MUD para minúsculas.
    "score"       => "[[sC'O*e]]",
    "kb"          => " quilobáites",
    "kib"         => " quibibáites",
    "kg"          => " quilogramas",
    "km"          => " quilômetros",
    "mb"          => " megabáites",
    "mib"         => " mebibáites",
    "away"        => "[[aU'eI]]",
    "exp"         => "ê xis pê",
    "flooder"     => "[[fl'uder]]",
    "gmail"       => "[[Z'e]] [[m'ejaU]]",
    "kildclient"  => "[[k'ild]] [[kl'aIent]]",
    "le?ve?l *up" => "[[l'EvEU]] [['&p]]",
    "le?ve?l"     => "[[l'EvEU]]",
    "help"        => "[[h'Elp]]",
    "mudd?ers"    => "[[m'&ders]]",
    "mudd?er"     => "[[m'&der]]",
    "music"       => "[[m'i;uzik]]",
    "osay"        => "Ô sei",
    "ot"          => "[['o]] [[t'e]]",
    "plorum"      => "plórum",
    "recall"      => "[[xek'Ow]]",

    # Termos tolkiendilli.
    "celeborn"    => "[[k'eleb,orn]]",
    "gandalf"     => "[[g'&~Nd&lf]]",
    "gollum"      => "[[g'Olu~N]]",
    "helm"        => "[[x'EUm]]",
    "elrond"      => "[['ElRoNd]]",
    "gondor"      => "gôndor",
    "hobbit"      => "[[R'Obit]]",
    "imladris"    => "[[iml'adris]]",
    "maiar"       => "[[m'aIar]]",
    "melkor"      => "[[m'elkor]]",
    "morgoth"     => "[[morg'o%ff]]",
    "reuel"       => "[[x'OIEU]]",
    "smaug"       => "[[sm'aug]]",
    "saruman"     => "[[s'a*um&~N]]",
    "silmarillion"=> "[[s,ilm\@r'ili\@n]]",
    "tirith"      => "[[t'iriT]]",
    "valar"       => "[[v'alar]]",
    "valinor"     => "[[v'Alin,or]]",
    "imladris"    => "[[iml'adRis]]",
    "elen"        => "[['EleIN]]",
    #"" => "[[]]",

    # Símbolos gráficos.
    "o.o"         => "*olhar arregalado*",
    "\\\\o\\/"    => "*braços ao ar*",
    "_o\\/"       => "*braços ao ar*",
    "\\\\o_"      => "*braços ao ar*",
    ":\\)"        => "*sorriso*",
    ":\\("        => "*triste*",
    ":D"          => "*sorriso*",
    ";\\)"        => "*piscando*",
    ":D"          => "*sorriso exagerado*",

    # Abreviações idiotas e miguxês.
    "axu"         => "acho",
    "eh"          => "é",
    "flw"         => "falou",
    "mta"         => "muita",
    "mto"         => "muito",
    "pq"          => "por que",
    "rofl"        => "*rola no chão rindo*",
    "tbm?"        => "também",
    "vcs"         => "vocês",
    "vc"          => "você",

    # Erros de ortografia comuns.
    "nao"         => "não",
    "ola"         => "olá",
    
    "m?[khau][khau ]{3,}[khau]" => "muá rá rá", # Sons repetitivos são chatos
    "[he][he ]{3,}[he]" => "rê rê rê"           # Sons repetitivos são chatos
);


# Abreviações com bordas (\b).
our %abbrevrepl = (
    "ex[.:]+"   => "exemplo",
    "sr."       => "senhor",
    "sra."      => "senhora",
    "etc.?"     => "etcétera"
);


# Usado para interpretação do campo "Saídas:" das salas.
our %exitrepl = (
    "e"  => "leste",
    "w"  => "oeste",
    "n"  => "norte",
    "s"  => "sul",
    "sw" => "sudoeste",
    "nw" => "noroeste",
    "ne" => "nordeste",
    "se" => "sudeste",
    "u"  => "acima",
    "d"  => "abaixo"
);

our @months = ( "janeiro", "fevereiro", "março", "abril", "maio", "junho",
    "julho", "agosto", "setembro", "outubro", "novembro", "dezembro" );


# ---------------------------------------------------------------------------

our $pipe = undef;

our $filter = undef;


$::world->hook('OnReceivedText', '/espeak::speak($hookdata)',
    { name => 'espeak:received' });

$::world->alias('^\/speak$', '/espeak::toggle',
    { name => 'espeak:toggle' });


sub UNLOAD {
    closepipe();
}

sub help {
    $::world->echonl("Plugin eSpeak para o Kildclient",
    "Comandos disponíveis:",
    "/speak         Ativa/desativa a fala",
    "",

    "Comandos não implementados (ainda)",
    "/vol +         Aumenta o volume em um nível.",
    "/vol +x        Aumenta o volume em X níveis.",
    "/vol -         Reduz o volume em um nível.",
    "/vol -x        Reduz o volume em X níveis.",

    "/pitch +       Aumenta a velocidade em um nível.",
    "/pitch +x      Aumenta a velocidade em X níveis.",
    "/pitch -       Reduz a velocidade em um nível.",
    "/pitch -x      Reduz a velocidade em X níveis.",

    "/skip          Pára o sintetizador e retoma a fala dos textos novos.",

    "/phonadd texto pronúncia Adiciona pronúncia especial para 'texto'.",
    "/phonrem texto           Exclui pronúncia especial para 'texto'.",
    "/phonlist                Lista as pronúncias especiais."
    );
}

sub setfilter {
    my ($f) = @_;
    if ($f) {
        $filter = $f;
        $::world->echonl("Novo filtro definido.");
    } else {
        $filter = undef;
        $::world->echonl("Filtro removido.");
    }
}


sub openpipe {
    if ($pipe) { return; }
    if (!open($pipe, "|$speakcmd")) {
        $::world->echonl("Comando '$speakcmd' falhou.");
        return;
    } else {
        # Perl makes me craaaazy! Isso equivale a uma saída não-bufferizada.
        my $old_fh = select($pipe);
        $| = 1;
        select($old_fh);
        $::world->echonl("eSpeak ativado.");
        speak("Sintetizador de fala ativado.");
    }
}

sub closepipe {
    if (!$pipe) { return; }
    close($pipe);
    $pipe = undef;
    $::world->echonl("eSpeak desativado.");
}


sub read_date {
    my ($dstr) = @_;
    my ($d, $m, $y) = split(/[\/.-]/, $dstr);
    $m = int($m);
    $d = int($d);
    if ($m > 0 && $m <= 12 && $d > 0 && $d <= 31) {
        if ($d == 1) {
            return "primeiro de " . $months[$m-1] . " de $y";
        } else {
            return "$d de " . $months[$m-1] . " de $y";
        }
    }
    return $dstr;
}


sub format_time {
    my ($h, $m) = @_;
    $h = int($h);
    $m = int($m);
    $ret = "";
    if ($h > 1) {
        $ret = "$h horas e";
    } else {
        $ret = "uma hora e";
    }
    if ($m > 1) {
        $ret = "$ret $m minutos";
    } else {
        $ret = "$ret um minuto";
    }
    return $ret;
}


sub speak {
    my ($text) = @_;

    if ($pipe) {
        $text = ::stripansi($text);
        
        # Prompt, canais de log, etc
        if ($text =~ m/^(:|Comm|Log|Auth|Build|Monitor):/ ) {
            return;
        }

        # WHO
        if ($text =~ m/^\[/ )  { return; }

        # Evita a pronúncia de números gigantescos (inclusive hexadecimais).
        $text =~ s/[0-9a-f]{6,}/ seqüência numérica longa /gi;

        # Datas e horas
        $text =~ s/([0-9]+[.\/-][0-9]+[.\/-][0-9]+)/read_date("$1")/ge;
        $text =~ s/\b([0-9]{1,2})[h: ]+([0-9]{1,2})["m: ]+([0-9]{1,2})?["s]?\b/format_time($1,$2)/ge;

        my($key, $value);
        while (($key, $value) = each(%subtbl)) {
            $text =~ s/\b$key\b/$value/ig;
        }
        
        while (($key, $value) = each(%abbrevrepl)) {
            $text =~ s/$key/$value/ig;
        }

        # Interpretação da lista de saídas. Será eliminado pelo modo aural.
        if ($text =~ /^Saídas: /) {
            $text =~ s/\s!/ fechado /ig;
            while (($key, $value) = each(%exitrepl)) {
                $text =~ s/\b$key\b/$value,/ig;
            }
        }

        # Quantidades, ex: (42x) uma toalha.
        $text =~ s/\(2x\)/duas vezes/ig;
        $text =~ s/\(([0-9]+)x\)/$1 vezes/ig;

        # Interpretar as hitbars, etc.
        # Suprimir ascii art?
        # Suprimir coisas como /[|+_=.-]/.

        #$::world->echonl("DEBUG: $text");
#        if ($filter) {
#            if ($text =~ m/$filter/i) {
#                print $pipe "$text\n";
#            }
#        } else {
           print $pipe "$text\n";
#        }
    }
}

sub toggle {
    if ($pipe) {
        closepipe();
    } else {
        openpipe();
    }
}

