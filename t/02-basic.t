use Test;
use Cmark;

my $doc = Cmark.parse("# Header 1");

isa-ok $doc , Cmark , "Type OK";

done-testing;
