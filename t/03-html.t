use Test;
use Cmark;

my $md = "# Header 1";
my $doc = Cmark.parse($md);

is $doc.to-html , "<h1>Header 1</h1>\n";

my $options = CMARK_OPT_SAFE;
$md = "[link](javascript:alert('xss'))";
$doc .= parse($md);

is $doc.to-html($options) , "<p><a href=\"\">link</a></p>\n";

$options = CMARK_OPT_UNSAFE;

is $doc.to-html($options) , '<p><a href="javascript:alert(&#x27;xss&#x27;)">link</a></p>' ~ "\n";

done-testing;
