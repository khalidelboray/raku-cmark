use NativeCall;
unit module Cmark::Native;



#________________________________________________Classes__________________________________________________________#
class Node is repr('CPointer') {

    multi method text {
        cmark_node_get_literal(self) // '';
    }

    multi method text($text) {
        cmark_node_set_literal(self,$text);
    }
    multi method type(:$str){
        cmark_node_get_type_string(self);
    }
    multi method type {
        cmark_node_get_type(self);
    }
    method list-type {
        return cmark_node_get_list_type(self)
    }

    method next {
        return cmark_node_next( self );
    }
    method previous {
        return cmark_node_previous( self );
    }
    method parent {
        return cmark_node_parent( self );
    }
    method first-child {
        return cmark_node_first_child( self );
    }
    method last-child {
        return cmark_node_last_child( self );
    }
    multi method render($options = 0,:$html!) {
        cmark_render_html(self,$options);
    }
    multi method render($options = 0,:$xml!) {
        cmark_render_xml(self,$options);
    }
    multi method render($options = 0 ,$width = 0,:$latex!) {
        cmark_render_latex(self,$options,$width);
    }
    multi method render($options = 0 ,$width = 0,:$commonmark!) {
        cmark_render_commonmark(self,$options,$width);
    }
    multi method render($options = 0 ,$width = 0,:$man!) {
        cmark_render_man(self,$options,$width);
    }
}
#| A class represents `cmark_parser`, i think
class Parser is repr('CPointer') {
    submethod BUILD(:$options) {
        cmark_parser_new($options);
    }
    multi method new($options) {
        self.bless(:$options);
    }

    #| Send a string to the parser
    method feed(Str $buff) {
        my $len = $buff.encode.bytes;
        cmark_parser_feed(self,$buff,$len);
    }

    #| Finish Parsing
    method finish {
       return cmark_parser_finish(self);
    }

    method parse($md) {
        self.feed($md);
        self.finish;
    }
    method DESTROY {
        cmark_parser_free(self);
    }
}


#
#enum EventType <CMARK_EVENT_NONE CMARK_EVENT_DONE CMARK_EVENT_ENTER CMARK_EVENT_EXIT>;
#class CIterator is repr('CPointer')    {
#
#    submethod BUILD(:$node) {
#        cmark_iter_new($node);
#    }
#
#    multi method new($node) {
#        self.bless(:$node);
#    }
#
#    submethod DESTROY {
#        cmark_iter_free( self )
#    }
#
#    method next {
#        return cmark_iter_next( self );
#    }
#
#    method node {
#        return cmark_iter_get_node( self );
#    }
#
#    method event-type {
#        return cmark_iter_get_event_type( self );
#    }
#
#    method root {
#        return cmark_iter_get_root( self );
#    }
#}
#________________________________________________Iterator__________________________________________________________#
#| Creates a new iterator starting at 'root'. The current node and event type are undefined until 'cmark_iter_next' is called for the first time. The memory allocated for the iterator should be released using 'cmark_iter_free' when it is no longer needed.
#| | `cmark_iter * cmark_iter_new(cmark_node *root)`
#sub cmark_iter_new( Node ) returns Pointer is native('cmark') is export { * }

#| Frees the memory allocated for an iterator.
#| | `void cmark_iter_free(cmark_iter *iter)`
#sub cmark_iter_free( CIterator) is native('cmark') is export { * }

#| Advances to the next node and returns the event type (`CMARK_EVENT_ENTER`, `CMARK_EVENT_EXIT` or `CMARK_EVENT_DONE`).
#| | `cmark_event_type cmark_iter_next(cmark_iter *iter)`
#sub cmark_iter_next( CIterator) returns int32 is native('cmark') is export { * }

#| Returns the current node.
#| | `cmark_node * cmark_iter_get_node(cmark_iter *iter)`
#sub cmark_iter_get_node( CIterator ) returns Node is native('cmark') is export { * }

#| Returns the current event type.
#| | `cmark_event_type cmark_iter_get_event_type(cmark_iter *iter)`
#sub cmark_iter_get_event_type( CIterator )  returns int32 is native('cmark') is export { * }

#| Returns the root node.
#| | `cmark_node * cmark_iter_get_root(cmark_iter *iter)`
#sub cmark_iter_get_root( CIterator )  returns Node is native('cmark') is export { * }
#________________________________________________Creating-and-Destroying-Nodes__________________________________________________________#

#| Creates a new node of type 'type'. Note that the node may have other required properties, which it is the caller's responsibility to assign.
#| | `cmark_node *cmark_node_new(cmark_node_type type);`
sub cmark_node_new( int32 ) returns Node is native('cmark') is export { * }

#| Frees the memory allocated for a node and any children.
#| | `void cmark_node_free(cmark_node *node)`
sub cmark_node_free( Node ) is native('cmark') is export { * }


#________________________________________________Tree-Traversal__________________________________________________________
#| Returns the next node in the sequence after 'node', or NULL if there is none.
#| | `cmark_node * cmark_node_next(cmark_node *node)`
sub cmark_node_next( Node ) returns Node is native('cmark') is export { * }

#| Returns the previous node in the sequence after 'node', or NULL if there is none.
#| | `cmark_node * cmark_node_previous(cmark_node *node)`
sub cmark_node_previous( Node ) returns Node is native('cmark') is export { * }

#| Returns the parent of 'node', or NULL if there is none.
#| | `cmark_node * cmark_node_parent(cmark_node *node)`
sub cmark_node_parent( Node ) returns Node is native('cmark') is export { * }

#| Returns the first child of 'node', or NULL if 'node' has no children.
#| | `cmark_node * cmark_node_first_child(cmark_node *node)`
sub cmark_node_first_child( Node ) returns Node is native('cmark') is export { * }

#| Returns the last child of 'node', or NULL if 'node' has no children.
#| | `cmark_node * cmark_node_last_child(cmark_node *node)`
sub cmark_node_last_child( Node ) returns Node is native('cmark') is export { * }


#________________________________________________Accessors__________________________________________________________#
#| Returns the user data of 'node'.
#| | `void * cmark_node_get_user_data(cmark_node *node)`
sub cmark_node_get_user_data(  Node ) returns Pointer is native('cmark') is export { * }

#| Sets arbitrary user data for 'node'. Returns 1 on success, 0 on failure.
#| | `int cmark_node_set_user_data(cmark_node *node, void *user_data)`
sub cmark_node_set_user_data(  Node, Pointer ) returns int32 is native('cmark') is export { * }

#| Returns the type of 'node', or `CMARK_NODE_NONE` on error.
#| | `cmark_node_type cmark_node_get_type(cmark_node *node)`
sub cmark_node_get_type(  Node ) returns int32 is native('cmark') is export { * }

#| Like `cmark_node_get_type`, but returns a string representation of the type, or "<unknown>".
#| | `const char * cmark_node_get_type_string(cmark_node *node)`
sub cmark_node_get_type_string(  Node ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Returns the string contents of 'node', or an empty string if none is set. Returns NULL if called on a node that does not have string content.
#| | `const char * cmark_node_get_literal(cmark_node *node)`
sub cmark_node_get_literal(  Node ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Sets the string contents of 'node'. Returns 1 on success, 0 on failure.
#| | `int cmark_node_set_literal(cmark_node *node, const char *content)`
sub cmark_node_set_literal(  Node, Str is encoded('utf8') ) returns int32 is native('cmark') is export { * }

#| Returns the heading level of 'node', or 0 if 'node' is not a heading.
#| | `int cmark_node_get_heading_level(cmark_node *node)`
sub cmark_node_get_heading_level(  Node ) returns int32 is native('cmark') is export { * }

#| Sets the heading level of 'node', returning 1 on success and 0 on error.
#| | `int cmark_node_set_heading_level(cmark_node *node, int level)`
sub cmark_node_set_heading_level(  Node, int32 ) returns int32 is native('cmark') is export { * }

#| Returns the list type of 'node', or `CMARK_NO_LIST` if 'node' is not a list.
#| | `cmark_list_type cmark_node_get_list_type(cmark_node *node)`
sub cmark_node_get_list_type(  Node ) returns int32 is native('cmark') is export { * }

#| Sets the list type of 'node', returning 1 on success and 0 on error.
#| | `int cmark_node_set_list_type(cmark_node *node, cmark_list_type type)`
sub cmark_node_set_list_type(  Node, int32 ) returns int32 is native('cmark') is export { * }

#| Returns the list delimiter type of 'node', or `CMARK_NO_DELIM` if 'node' is not a list.
#| | `cmark_delim_type cmark_node_get_list_delim(cmark_node *node)`
sub cmark_node_get_list_delim(  Node ) returns int32 is native('cmark') is export { * }

#| Sets the list delimiter type of 'node', returning 1 on success and 0 on error.
#| | `int cmark_node_set_list_delim(cmark_node *node, cmark_delim_type delim)`
sub cmark_node_set_list_delim(  Node, int32 ) returns int32 is native('cmark') is export { * }

#| Returns starting number of 'node', if it is an ordered list, otherwise 0.
#| | `int cmark_node_get_list_start(cmark_node *node)`
sub cmark_node_get_list_start(  Node ) returns int32 is native('cmark') is export { * }

#| Sets starting number of 'node', if it is an ordered list. Returns 1 on success, 0 on failure.
#| | `int cmark_node_set_list_start(cmark_node *node, int start)`
sub cmark_node_set_list_start(  Node, int32 ) returns int32 is native('cmark') is export { * }

#| Returns 1 if 'node' is a tight list, 0 otherwise.
#| | `int cmark_node_get_list_tight(cmark_node *node)`
sub cmark_node_get_list_tight(  Node ) returns int32 is native('cmark') is export { * }

#| Sets the "tightness" of a list. Returns 1 on success, 0 on failure.
#| | `int cmark_node_set_list_tight(cmark_node *node, int tight)`
sub cmark_node_set_list_tight(  Node, int32 ) returns int32 is native('cmark') is export { * }

#| Returns the info string from a fenced code block.
#| | `const char * cmark_node_get_fence_info(cmark_node *node)`
sub cmark_node_get_fence_info(  Node ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Sets the info string in a fenced code block, returning 1 on success and 0 on failure.
#| | `int cmark_node_set_fence_info(cmark_node *node, const char *info)`
sub cmark_node_set_fence_info(  Node, Str is encoded('utf8') ) returns int32 is native('cmark') is export { * }

#| Returns the URL of a link or image 'node', or an empty string if no URL is set. Returns NULL if called on a node that is not a link or image.
#| | `const char * cmark_node_get_url(cmark_node *node)`
sub cmark_node_get_url(  Node ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Sets the URL of a link or image 'node'. Returns 1 on success, 0 on failure.
#| | `int cmark_node_set_url(cmark_node *node, const char *url)`
sub cmark_node_set_url(  Node, Str is encoded('utf8') ) returns int32 is native('cmark') is export { * }

#| Returns the title of a link or image 'node', or an empty string if no title is set. Returns NULL if called on a node that is not a link or image.
#| | `const char * cmark_node_get_title(cmark_node *node)`
sub cmark_node_get_title(  Node ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Sets the title of a link or image 'node'. Returns 1 on success, 0 on failure.
#| | `int cmark_node_set_title(cmark_node *node, const char *title)`
sub cmark_node_set_title(  Node, Str is encoded('utf8') ) returns int32 is native('cmark') is export { * }

#| Returns the literal "on enter" text for a custom 'node', or an empty string if no on_enter is set. Returns NULL if called on a non-custom node.
#| | `const char * cmark_node_get_on_enter(cmark_node *node)`
sub cmark_node_get_on_enter(  Node ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Sets the literal text to render "on enter" for a custom 'node'. Any children of the node will be rendered after this text. Returns 1 on success 0 on failure.
#| | `int cmark_node_set_on_enter(cmark_node *node, const char *on_enter)`
sub cmark_node_set_on_enter(  Node, Str is encoded('utf8') ) returns int32 is native('cmark') is export { * }

#| Returns the literal "on exit" text for a custom 'node', or an empty string if no on_exit is set. Returns NULL if called on a non-custom node.
#| | `const char * cmark_node_get_on_exit(cmark_node *node)`
sub cmark_node_get_on_exit(  Node ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Sets the literal text to render "on exit" for a custom 'node'. Any children of the node will be rendered before this text. Returns 1 on success 0 on failure.
#| `int cmark_node_set_on_exit(cmark_node *node, const char *on_exit)`
sub cmark_node_set_on_exit(  Node, Str is encoded('utf8') ) returns int32 is native('cmark') is export { * }

#| Returns the line on which 'node' begins.
#| | `int cmark_node_get_start_line(cmark_node *node)`
sub cmark_node_get_start_line(  Node ) returns int32 is native('cmark') is export { * }

#| Returns the column at which 'node' begins.
#| | `int cmark_node_get_start_column(cmark_node *node)`
sub cmark_node_get_start_column(  Node ) returns int32 is native('cmark') is export { * }

#| Returns the line on which 'node' ends.
#| | `int cmark_node_get_end_line(cmark_node *node)`
sub cmark_node_get_end_line(  Node ) returns int32 is native('cmark') is export { * }

#| Returns the column at which 'node' ends.
#| | `int cmark_node_get_end_column(cmark_node *node)`
sub cmark_node_get_end_column(  Node ) returns int32 is native('cmark') is export { * }



#________________________________________________Rendering__________________________________________________________#
#| Render the Node to XML
#| | `char *cmark_render_xml(cmark_node *root, int options);`
sub cmark_render_xml( Node, int32 ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Render the Node to HTML
#| | `char *cmark_render_html(cmark_node *root, int options);`
sub cmark_render_html( Node, int32 ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Render the Node to man
#| | `char *cmark_render_man(cmark_node *root, int options, int width);`
sub cmark_render_man( Node, int32, int32 ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Render the Node to CommonMark
#| | `char *cmark_render_commonmark(cmark_node *root, int options, int width);`
sub cmark_render_commonmark( Node, int32, int32 ) returns Str is encoded('utf8') is native('cmark') is export { * }

#| Render the Node to latex
#| | `char *cmark_render_latex(cmark_node *root, int options, int width);`
sub cmark_render_latex( Node, int32, int32 ) returns Str is encoded('utf8') is native('cmark') is export { * }

#________________________________________________Version-information__________________________________________________________#
#| The library version as integer for runtime checks
#| | `int cmark_version(void)`
sub cmark_version(--> int32) is native('cmark') is export { * }

#| The library version string for runtime checks.
#| | `const char * cmark_version_string(void)`
sub cmark_version_string(--> Str) is native('cmark') is export { * }

#________________________________________________Parsing__________________________________________________________#

#| Creates a new parser object.
#| | `cmark_parser * cmark_parser_new(int options)`
sub cmark_parser_new( int32 ) returns Pointer is native('cmark') is export { * }

#| Frees memory allocated for a parser object.
#| | `void cmark_parser_free(cmark_parser *parser)`
sub cmark_parser_free( Parser ) is native('cmark') is export { * }

#| Feeds a string of length 'len' to 'parser'.
#| | `void cmark_parser_feed(cmark_parser *parser, const char *buffer, size_t len)`
sub cmark_parser_feed( Parser, Str is encoded('utf8'), size_t ) is native('cmark') is export { * }

#| Finish parsing and return a pointer to a tree of nodes.
#| | `cmark_node * cmark_parser_finish(cmark_parser *parser)`
sub cmark_parser_finish( Parser ) returns Node is native('cmark') is export { * }


sub cmark_parse_document(Str ,size_t,int32) returns Node is native('cmark') is export { * }
#________________________________________________Tree-Manipulation__________________________________________________________#

#| Unlinks a 'node', removing it from the tree, but not freeing its memory. (Use 'cmark_node_free' for that.)
#| | `void cmark_node_unlink(cmark_node *node)`
sub cmark_node_unlink( Node ) is native('cmark') is export { * }

#| Inserts 'sibling' before 'node'. Returns 1 on success, 0 on failure.
#| | `int cmark_node_insert_before(cmark_node *node, cmark_node *sibling)`
sub cmark_node_insert_before( Node, Node ) returns int32 is native('cmark') is export { * }

#| Inserts 'sibling' after 'node'. Returns 1 on success, 0 on failure.
#| | `int cmark_node_insert_after(cmark_node *node, cmark_node *sibling)`
sub cmark_node_insert_after( Node, Node ) returns int32 is native('cmark') is export { * }

#| Replaces 'oldnode' with 'newnode' and unlinks 'oldnode' (but does not free its memory). Returns 1 on success, 0 on failure.
#| | `int cmark_node_replace(cmark_node *oldnode, cmark_node *newnode)`
sub cmark_node_replace( Node, Node ) returns int32 is native('cmark') is export { * }

#| Adds 'child' to the beginning of the children of 'node'. Returns 1 on success, 0 on failure.
#| | `int cmark_node_prepend_child(cmark_node *node, cmark_node *child)`
sub cmark_node_prepend_child( Node, Node ) returns int32 is native('cmark') is export { * }

#| Adds 'child' to the end of the children of 'node'. Returns 1 on success, 0 on failure.
#| | `int cmark_node_append_child(cmark_node *node, cmark_node *child)`
sub cmark_node_append_child( Node, Node ) returns int32 is native('cmark') is export { * }

#| Consolidates adjacent text nodes.
#| | `void cmark_consolidate_text_nodes(cmark_node *root)`
sub cmark_consolidate_text_nodes( Node ) is native('cmark') is export { * }
