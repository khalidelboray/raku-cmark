use Cmark::Native;
#| Main Class
unit class Cmark;

has $.node;
has $.options is rw;

enum OPTIONS is export (
    CMARK_OPT_DEFAULT => 0,
    CMARK_OPT_SOURCEPOS =>  1 +< 1,
    CMARK_OPT_HARDBREAKS  => 1 +< 2,
    CMARK_OPT_SAFE => 1 +< 3,
    CMARK_OPT_UNSAFE => 1 +< 17,
    CMARK_OPT_NOBREAKS => 1 +< 4,
    CMARK_OPT_NORMALIZE => 1 +< 8,
    CMARK_OPT_VALIDATE_UTF8 => 1 +< 9 ,
    CMARK_OPT_SMART => 1 +< 10
);


multi method parse(::CLASS:U: Str $md,$options = CMARK_OPT_DEFAULT) returns Cmark {
    my $node = cmark_parse_document($md,$md.chars,$options);
    return self.bless(:$node,:$options);
}

multi method parse(::CLASS:U: IO $md,$options = CMARK_OPT_DEFAULT) returns Cmark {
    samewith($md.slurp,$options);
}

multi method parse(::CLASS:D: $md , $options = CMARK_OPT_DEFAULT) {
    my $node = cmark_parse_document($md,$md.chars,$options);
    self.node = $node;
}

method to-html($options = $!options) {
    cmark_render_html($!node,$options);
}

method to-xml($options = $!options) {
    cmark_render_xml($!node,$options);
}

method to-man($options = $!options , :$width = 0) {
    cmark_render_man($!node,$options,$width);
}

method to-commonmark($options = $!options,:$width = 0) {
    cmark_render_commonmark($!node,$options,$width);
}

method to-latex($options = $!options,:$width =  0) {
    cmark_render_latex($!node,$options,$width);
}

method version {
    cmark_version_string;
}
