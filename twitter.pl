package twitter;
#: Version: 0.0.2
#: Description: Updates your Twitter status from KildClient
#: Author: Alexandre "dermeister" Erwin Ittner
#-*- coding: utf-8 -*-

# ---------------------------------------------------------------------------
#
# This program is distributed under the terms of the GNU General Public
# License version 2 or, at your option, any later version of the license.
# THIS PROGRAM HAVE NO WARRANTY OF ANY KIND. USE AT YOUR OWN RISK!
#
#
# TO DO List:
#   * Show 'KildClient' as source.
#   * Interpret return messages.
#   * Asynchronous networking to avoid freezing KC.
#   * Remember passwords (Needs some security. Gnome Keyring?)
#   * Capture and send game-related events (needs asynchronous calls).
#   * Support more protocol methods.
#   * Turn Twitter into something useful.
#
# ---------------------------------------------------------------------------

use LWP::UserAgent;

$proto = 'http://';
$proto = 'https://' if eval("use Crypt::SSLeay;");

# Configuration -------------------------------------------------------------

our $tw_status_url  = $proto . 'twitter.com/statuses/update.xml';
our $tw_auth_realm  = 'Twitter API';
our $tw_auth_host   = 'twitter.com:80';
our $tw_source      = 'KildClient';
our $user_agent     = 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.14) Gecko/20080418';


# ---------------------------------------------------------------------------

our $agent;

$::world->alias('^\/twauth +([^ ]+) (.+)$', '/twitter::auth("$1", "$2")',
    { name => 'twitter:auth' });

$::world->alias('^\/twstatus +(.+)$', '/twitter::status("$1")',
    { name => 'twitter:status' });

sub help {
    $::world->echonl(<<_HELP_
Updates your Twitter status from within KildClient. 

Commands:
    /twauth <login> <password>  Enables the plugin and stores your Twitter
                                credentials. To allow passwords beginning with
                                a space, login and password must be separated
                                by _exactly one_ space.

    /twstatus <status>          Sets your Twitter status to <status>.

_HELP_
);
}

sub auth {
    ($user, $pass) = @_;
    $agent = LWP::UserAgent->new();
    $agent->credentials($tw_auth_host, $tw_auth_realm, $user, $pass);
    $agent->agent($user_agent);
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


