use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Plack::Middleware::Session::FixationDefender',
    AUTHOR              => 'Shinichiro Aska <s.aska.org@gmail.com>',
    VERSION_FROM        => 'lib/Plack/Middleware/Session/FixationDefender.pm',
    ABSTRACT_FROM       => 'lib/Plack/Middleware/Session/FixationDefender.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Plack::Middleware::Session' => 0,
        'Test::More'                 => 0,
        'version'                    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Plack-Middleware-Session-FixationDefender-*' },
);
