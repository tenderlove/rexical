#
# xhtmlparser.rex
# lexical scanner definition for rex
#
# usage
#   rex  xhtmlparser.rex  --stub
#   ruby xhtmlparser.rex.rb  sample.xhtml
#

class XHTMLParser
option
  ignorecase

macro
  BLANK         \s+
  TAG_IN        \<
  TAG_OUT       \>
  ETAG_IN       \<\/
  ETAG_OUT      \/\>
  XTAG_IN       \<\?
  XTAG_OUT      \?\>
  EXT           \!
  REM           \-\-
  EQUAL         \=
  Q1            \'
  Q2            \"

rule

# [:state]  pattern  [actions]
                {XTAG_IN}               { self.state = :TAG; [:xtag_in, text] }
                {ETAG_IN}               { self.state = :TAG; [:etag_in, text] }
                {TAG_IN}                { self.state = :TAG; [:tag_in, text] }
  :TAG          {EXT}                   { self.state = :EXT; [:ext, text] }

  :EXT          {REM}                   { self.state = :REM; [:rem_in, text] }
  :EXT          {XTAG_OUT}              { self.state = nil;  [:xtag_out, text] }
  :EXT          {TAG_OUT}               { self.state = nil;  [:tag_out, text] }
  :EXT          .+(?={REM})             {               [:exttext, text] }
  :EXT          .+(?={TAG_OUT})         {               [:exttext, text] }
  :EXT          .+(?=$)                 {               [:exttext, text] }
  :EXT          \n

  :REM          {REM}                   { self.state = :EXT; [:rem_out, text] }
  :REM          .+(?={REM})             {               [:remtext, text] }
  :REM          .+(?=$)                 {               [:remtext, text] }
  :REM          \n

  :TAG          {BLANK}
  :TAG          {XTAG_OUT}              { self.state = nil;  [:xtag_out, text] }
  :TAG          {ETAG_OUT}              { self.state = nil;  [:etag_out, text] }
  :TAG          {TAG_OUT}               { self.state = nil;  [:tag_out, text] }
  :TAG          {EQUAL}                 {               [:equal, text] }
  :TAG          {Q1}                    { self.state = :Q1;  [:quote1, text] } # '
  :Q1           {Q1}                    { self.state = :TAG; [:quote1, text] } # '
  :Q1           [^{Q1}]+(?={Q1})        {               [:value, text] }  # '
  :TAG          {Q2}                    { self.state = :Q2;  [:quote2, text] } # "
  :Q2           {Q2}                    { self.state = :TAG; [:quote2, text] } # "
  :Q2           [^{Q2}]+(?={Q2})        {               [:value, text] }  # "

  :TAG          [\w\-]+(?={EQUAL})      {               [:attr, text] }
  :TAG          [\w\-]+                 {               [:element, text] }

                \s+(?=\S)
                .*\S(?=\s*{ETAG_IN})    {               [:text, text] }
                .*\S(?=\s*{TAG_IN})     {               [:text, text] }
                .*\S(?=\s*$)            {               [:text, text] }
                \s+(?=$)

inner

end
