use NativeCall;
use NativeLibs;
unit module Cmark::Raw;

constant lib = $*DISTRO.is-win ?? 'libcmark.dll' !! 'libcmark.so';
class Node is repr('CStruct') {
    has Node $.next;
    has Node $.prev;
    has Node $.parent;
    has Node $.first_child;
    has Node $.last_child;
    has Pointer $.user_data;
    has Str $.data;
    has int32 $.len;
    has int $.start_line;
    has int $.start_column;
    has int $.end_line;
    has int $.end_column;
    has int $.internal_offset;
    has uint16 $.type;
    has uint16 $.flags;

}




sub cmark_version_string(--> Str) is native(lib) is export {*}
sub cmark_markdown_to_html(Str $text , size_t $len , int32 $options --> Str) is native(lib) is export {*}
sub cmark_parse_document(Str $text,size_t $len,int32 $options --> Node) is native(lib) is export {*}
sub cmark_render_html(Node $node ,int32 $options --> Str) is native(lib) is export {*}
sub cmark_render_xml(Node $node ,int32 $options --> Str) is native(lib) is export {*}
sub cmark_render_man(Node $node ,int32 $options , int32 $width --> Str) is native(lib) is export {*}
sub cmark_render_commonmark(Node $node ,int32 $options , int32 $width --> Str) is native(lib) is export {*}
sub cmark_render_latex(Node $node ,int32 $options , int32 $width --> Str) is native(lib) is export {*}
