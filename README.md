# Cmark

### DESCRIPTION

A Raku binding (*NOT COMPLETED*) to the C lib [cmark](https://github.com/commonmark/cmark) *trying*

# Example

``` perl6
    use Cmark;
    my $options = CMARK_OPT_UNSAFE +| CMARK_OPT_SOURCEPOS  ;
    my $doc = Cmark.parse("# Header [hello](javascript:alert(1))",$options);
    say $doc.to-html();  # <h1 data-sourcepos="1:1-1:37">Header <a href="javascript:alert(1)">hello</a></h1>
```

## Class `Cmark` Methods

* ### multi method parse

    ```perl6
    multi method parse(
        Str $md,
        $options = 0
    ) returns Cmark
    ```
    
    takes the markdown as a Str and the parser options 
* ### multi method parse
    
    ```perl6
      multi method parse(
          IO $md,
          $options = 0
      ) returns Cmark
    ```
    takes the markdown file and passes it's content to the previous one

* ### version
    ```perl6
      method version ()
    ```
    returns the cmark vserion string
    
## OPTIONS

```perl6
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
```
* `CMARK_OPT_DEFAULT`    
    > Default options. 
* `CMARK_OPT_SOURCEPOS`
    > Include a `data-sourcepos` attribute on all block elements. 
* `CMARK_OPT_HARDBREAKS`
    > Render `softbreak` elements as hard line breaks. 
* `CMARK_OPT_SAFE`
    > `CMARK_OPT_SAFE` is defined here for API compatibility, but it no longer has any effect. "Safe" mode is now the default: set `CMARK_OPT_UNSAFE` to disable it. 
* `CMARK_OPT_UNSAFE`
    > Render raw HTML and unsafe links (`javascript:`, `vbscript:`, `file:`, and `data:`, except for `image/png`, `image/gif`, `image/jpeg`, or `image/webp` mime types). By default, raw HTML is replaced by a placeholder HTML comment. Unsafe links are replaced by empty strings. 
* `CMARK_OPT_NOBREAKS`
    > Render `softbreak` elements as spaces. 
* `CMARK_OPT_NORMALIZE`
    > Legacy option (no effect). 
* `CMARK_OPT_VALIDATE_UTF8`
    > Validate UTF-8 in the input before parsing, replacing illegal sequences with the replacement character U+FFFD. 
* `CMARK_OPT_SMART`
    > Convert straight quotes to curly, to em dashes, - to en dashes. 
    
## Doc Methods   

* ### to-html
    ```perl6
      method to-html (
          $options = $!options
      )
    ```
    Converts the parsed Markdown to html given the options (defaults to the options used with parse)

* ### to-xml
    ```perl6
      method to-xml (
          $options = $!options
      )
    ```
    Converts the parsed Markdown to xml given the options (defaults to the options used with parse)

* ### to-man
    ```perl6
      method to-man (
          $options = $!options,
          :$width = 0
      )
    ```
    Converts the parsed Markdown to man given the options (defaults to the options used with parse) and width

* ### to-commonmark
    ```perl6
      method to-commonmark (
          $options = $!options,
          :$width = 0
      )
    ```
    Converts the parsed Markdown to commnmark given the options (defaults to the options used with parse)  and width
* ### to-latex
    ```perl6
      method to-latex (
          $options = $!options,
          :$width = 0
      )
    ```
    Converts the parsed Markdown to latex given the options (defaults to the options used with parse)  and width


## TODO 
* Add more tests
* Full binding 
    * `cmark_parser_new_with_mem` ,`cmark_parser_new` ,`cmark_parser_free`,`cmark_parse_file`,`cmark_parser_feed`,`cmark_parser_finish`,`cmark_node_free`,''
