#
# sample2.rex
# lexical definition sample for rex
#
# usage
#  rex  sample2.rex  --stub
#  ruby sample2.rex.rb  sample2.bas
#

class Sample2
option
  ignorecase

macro
  BLANK         \s+
  REMARK        \'              # '

rule
                {REMARK}        { self.state = :REM;  [:rem_in, text] } # '
  :REM          \n              { self.state = nil;   [:rem_out, text] }
  :REM          .*(?=$)         {                [:remark, text] }

                \"[^"]*\"       { [:string, text] } # "

                {BLANK}         # no action

                INPUT           { [:input, text] }
                PRINT           { [:print, text] }

                \d+             { [:digit, text.to_i] }
                \w+             { [:word, text] }
                .               { [text, text] }
end
