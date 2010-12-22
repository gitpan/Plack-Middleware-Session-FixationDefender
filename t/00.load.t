use Test::More tests => 1;

BEGIN {
use_ok( 'Plack::Middleware::Session::FixationDefender' );
}

diag( "Testing Plack::Middleware::Session::FixationDefender $Plack::Middleware::Session::FixationDefender::VERSION" );
