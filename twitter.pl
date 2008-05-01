package twitter;
#: Version: 0.0.1
#: Description: Cliente do Twitter para o KildClient
#: Author: Alexandre "dermeister" Erwin Ittner
#-*- coding: utf-8 -*-

# Licença: GPLv2
# CUIDADO! Software em seus primeiros estágios de desenvolvimento!

use LWP::UserAgent;


# Configuração --------------------------------------------------------------

our $tw_status_url = 'http://twitter.com/statuses/update.xml';
our $tw_auth_realm = 'Twitter API';
our $tw_auth_host  = 'twitter.com:80';
our $tw_source     = 'KildClient';


# ---------------------------------------------------------------------------

our $agent;

$::world->alias('^\/twauth +([^ ]+) (.+)$', '/twitter::auth("$1", "$2")',
    { name => 'twitter:auth' });

$::world->alias('^\/twstatus +(.+)$', '/twitter::status("$1")',
    { name => 'twitter:status' });

sub help {
    $::world->echonl("Plugin para usar o Twitter com o KildClient",
        "",
        "Comandos disponíveis:",
        "/twauth <login> <senha>    Autentica o cliente (login não pode ter espaços)",
        "/twstatus <status>         Atualiza seu status no twitter",
        ""
    )
}

sub auth {
    ($user, $pass) = @_;
    $agent = LWP::UserAgent->new();
    $agent->credentials($tw_auth_host, $tw_auth_realm, $user, $pass);
    $agent->agent('Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.14) Gecko/20080418');
    $agent->env_proxy();
    $::world->echonl("Usuário autenticado (ou não...)");
}

sub status {
    ($status) = @_;
    unless ($agent) {
        $::world->echonl("Use /twauth <login> <senha> antes.");
        return;
    }
    utf8::encode($status);
    my $res = $agent->post($tw_status_url,
        [ status => $status, source => $tw_source ]);
    $::world->echonl("Resultado: " . $res->code . " " . $res->message);
}




