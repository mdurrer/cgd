#!/usr/bin/perl

sub pr
{
	my ($fn) = @_;
	print "$fn\n";
	if ($fn =~ /.bak/i)
	{ print "-- deleted\n"; `rm "$fn"`}
}

while (<>)
{
	($cs, $fn) = /^(.*)\s+\*(.*)\n$/;
	if ($cs eq $lastcs)
	{
		print "\n" if (!$next);
		print "$lastfn\n" if (!$next);
		pr $fn;
		$next = 1;
	}
	else
	{ $next = 0; }
	$lastcs = $cs;
	$lastfn = $fn;
}
