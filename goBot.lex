structure Tokens = Tokens

type pos = int
type svalue = Tokens.svalue
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult= (svalue,pos) token

val pos = ref 0
fun teste() = print "oi";
fun eof () = Tokens.EOF(!pos,!pos)
fun error (e,l : int,_) = TextIO.output (TextIO.stdOut, String.concat[
	"line ", (Int.toString l), ": ", e, "\n"
      ])

%%
%header (functor GoBotLexFun(structure Tokens: GoBot_TOKENS));
alpha=[A-Za-z];
digit=[0-9];
op =[-+*/%><=^];
ws = [\ \t];
dots =[.,;:~!?];
alls = {alpha}|{digit}|{op}|{ws}|{dots};
%%
\n       => (pos := (!pos) + 1; lex());
{ws}+    => (lex());
{digit}+ => (Tokens.NUM (valOf (Int.fromString yytext), !pos, !pos));

"int"   => (Tokens.TYPE(yytext,!pos,!pos));

"getEnergy"   => (Tokens.GET_ENERGY(!pos,!pos));
"getLight"   => (Tokens.GET_LIGHT(!pos,!pos));
"getTemp"   => (Tokens.GET_TEMP(!pos,!pos));

"moveA"   => (Tokens.MOVEA(!pos,!pos));
"moveB"   => (Tokens.MOVEB(!pos,!pos));
"moveE"   => (Tokens.MOVEE(!pos,!pos));
"moveD"   => (Tokens.MOVED(!pos,!pos));

{op}|"or"|">="|"<="|"!="|"and"  => (Tokens.OPERB(yytext,!pos,!pos));
";"      => (Tokens.SEMI(!pos,!pos));
"<-"      => (Tokens.ATR(!pos,!pos));

"("		=> (Tokens.LPAR(!pos,!pos));
")"		=> (Tokens.RPAR(!pos,!pos));
"delay"       => (Tokens.HOWAMI(!pos,!pos));
"if"       => (Tokens.IF(!pos,!pos));
"endif"       => (Tokens.ENDIF(!pos,!pos));
"show"      => (Tokens.SHOW(!pos,!pos));
"mapa"      => (Tokens.MAPA(!pos,!pos));
"noop"      => (Tokens.NOOP(!pos,!pos));
"not"      => (Tokens.NOT(!pos,!pos));
"true"      => (Tokens.TRUE(!pos,!pos));
"false"      => (Tokens.FALSE(!pos,!pos));

"print"   => (Tokens.PRINT(!pos,!pos));

{alpha}({alpha}|{digit})* => (Tokens.ID(yytext,!pos,!pos));
\" {alls}* \" =>   (Tokens.TEXTO(yytext,!pos,!pos) ); 

"."      => (error ("ignoring bad character "^yytext,!pos,!pos);
             lex());
