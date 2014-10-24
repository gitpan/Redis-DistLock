
use strict;
use warnings;

use Test::More;

use_ok( "Redis::DistLock" );

my $redis = bless( { version => "2.6.12" }, "My::Redis" );

my @tests = (
    [ 1, 1, "edge-case for single server" ],
    [ 2, 2, "with two, both need to have it to be safe" ],
    [ 3, 2, "with three, two are the majority" ],
    [ 4, 3, "with four, three are needed" ],
);

for my $test ( @tests ) {
    my $rd = Redis::DistLock->new(
        servers => [ ( $redis ) x $test->[0] ],
    );
    ok( $rd->{quorum} == $test->[1], $test->[2] );
}

done_testing();

package My::Redis;

use strict;
use warnings;

sub info {
    return { redis_version => $_[0]{version} };
}

sub script_load {
    return Redis::DistLock::RELEASE_SHA1();
}

1;

# vim: ts=4 sw=4 et:
