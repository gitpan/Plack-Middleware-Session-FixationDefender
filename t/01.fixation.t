use Plack::Test;
use Plack::Middleware::Session::FixationDefender;
use Test::More;
use HTTP::Request::Common;
use HTTP::Cookies;

my $app = sub {
    my $env = shift;
    my $counter = $env->{'psgix.session'}->{counter} || 0;

    my $body = "Counter=$counter";
    $env->{'psgix.session'}->{counter} = $counter + 1;
    $env->{'psgix.session.options'}->{'change_id'}++;

    return [ 200, [ 'Content-Type', 'text/html' ], [ $body ] ];
};

$app = Plack::Middleware::Session::FixationDefender->wrap($app);

test_psgi $app, sub {
    my $cb = shift;

    my $jar = HTTP::Cookies->new;

    my $res = $cb->(GET "http://localhost/");
    is $res->content_type, 'text/html';
    is $res->content, "Counter=0";
    $jar->extract_cookies($res);

    my $req = GET "http://localhost/";
    $jar->add_cookie_header($req);
    $res = $cb->($req);
    my ($sid) = $res->{'_headers'}->{'set-cookie'}=~/plack_session=(\w+);/;
    is $res->content, "Counter=1";

    $jar = HTTP::Cookies->new;
    $jar->extract_cookies($res);
    $req = GET "http://localhost/";
    $jar->add_cookie_header($req);
    $res = $cb->($req);
    my ($sid2) = $res->{'_headers'}->{'set-cookie'}=~/plack_session=(\w+);/;
    is $res->content, "Counter=2";
    isnt $sid, $sid2;    
};

done_testing;

