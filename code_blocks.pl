use strict ; use warnings ;

use JSON::XS ;
use Data::Walk ;
use Data::TreeDumper ;

my $str = do { local $/; <STDIN> };
my $json = decode_json $str ;

my %out =
	(
	blocks => [],
	"pandoc-api-version" => $json->{"pandoc-api-version"},
	meta => $json->{meta},
	) ;
my @containers ;
my @codeblocks ;

my $block_index=0 ;
for my $blocks ($json->{blocks})
	{
	for my $block ($blocks->@*)
		{
$block_index++ ;
		if($block->{t} eq 'CodeBlock')
			{
			my $type = $block->{c}[0][1][0] // 'none';
			my $pos = $block->{c}[0][2][0][1] // 'no position' ;
			# print STDERR "$type @ $pos\n" ;
			
			push @codeblocks, sprintf("$block_index, %-12s, $pos", $type) ;
			}
		else
			{
			push $out{blocks}->@*, $block ;
			}
		}
	}

print STDERR "$_\n" for @codeblocks ;

# my $js = JSON::XS->new->canonical->pretty(1) ;
# print $js->encode(\%out) ;

