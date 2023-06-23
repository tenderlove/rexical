#
# sample1.rex
# lexical definition sample for rex
#
# usage
#  rex  sample1.rex  --stub
#  ruby sample1.rex.rb  sample1.c
#

class Sample1
macro
  BLANK         \s+
  REM_IN        \/\*
  REM_OUT       \*\/
  REM           \/\/

rule

# [:state]  pattern  [actions]

# remark
                {REM_IN}        { self.state = :REMS; [:rem_in, text] }
  :REMS         {REM_OUT}       { self.state = nil;   [:rem_out, text] }
  :REMS         .*(?={REM_OUT}) {                [:remark, text] }
                {REM}           { self.state = :REM;  [:rem_in, text] }
  :REM          \n              { self.state = nil;   [:rem_out, text] }
  :REM          .*(?=$)         {                [:remark, text] }

# literal
                \"[^"]*\"       { [:string, text] } # "
                \'[^']\'        { [:character, text] } # '

# skip
                {BLANK}         # no action

# numeric
                \d+             { [:digit, text.to_i] }

# identifier
                \w+             { [:word, text] }
                .               { [text, text] }

end
