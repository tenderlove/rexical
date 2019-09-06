#
# error2.rex
# lexical definition sample for rex
#

class Error2
macro
  BLANK         [\ \t]+
rule
  {BLANK}       # no action
  \d+           { [:digit, text.to_i] }
  \w+           { [:word, text] }
  \n
  .             { self.state = :NONDEF ; [text, text] }
end
