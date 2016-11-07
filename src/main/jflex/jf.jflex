import java.lang.System;
import java.io.*;

class Yytoken {
  Yytoken
    (
     int index,
     String text,
     int line,
     int charBegin,
     int charEnd
     )
      {
	m_index = index;
	m_text = new String(text);
	m_line = line;
	m_charBegin = charBegin;
	m_charEnd = charEnd;
      }

  public int m_index;
  public String m_text;
  public int m_line;
  public int m_charBegin;
  public int m_charEnd;
  public String toString() {

String token[] = {"semicolon","eq","plus","minus","inc","dec","mod", "<>", "less","leq","greater","geq","AND",
"OR","KeyW_Skip","KeyW_Write","KeyW_Then","KeyW_Read","KeyW_While","KeyW_Do","KeyW_If","KeyW_Else",
"Text","Text","Number","Var", "Power", "open_br", "close_br", "Comment", "Extended_Comment"};

      return token[m_index]+" : "+m_text+" (line "+m_line+", pos "
	  +m_charBegin+":"+m_charEnd+" )";
  }
}

class Application {
public static void main(String argv[]) throws java.io.IOException {
    Application app = new Application();
    String inputFile;
    if(argv.length != 0){
        inputFile = argv[0];
        if(argv.length > 1 && argv[1].equals("-filter")){
            app.print(inputFile, false);
        }else{
             app.print(inputFile, true);
        }
    }else{
        System.out.println("No arguments there.");
        inputFile = "input.txt";
        app.print(inputFile, false);
    }
    }

    void print(String inputFile, Boolean f) throws java.io.IOException{
	Lexer yy = new Lexer(new FileReader(inputFile));
	if(f == false){
	    yy.filter = false;
	}else{
	      yy.filter = true;
	}

	Yytoken t;
	do {
	try{
	    t = yy.yylex();
	    if(t == null){
        System.out.println("***Programm over***");
        break;
        }
        System.out.println(t);
	    }catch(Error e){
	        System.out.println("Unresolved symbol was found");
            break;
	    }

	} while (true);
	}
}


%%

%{
  public Boolean filter;
  private int comment_count = 0;
  private int br_count = 0;
%}

%class  Lexer
%line
%char
%state COMMENT
%unicode

ALPHA=[A-Za-z]
DIGIT=[0-9]
NONNEWLINE_WHITE_SPACE_CHAR=[\ \t\b\012]
NEWLINE=\r|\n|\r\n
WHITE_SPACE_CHAR=[\n\r\ \t\b\012]
STRING_TEXT=(\\\"|[^\n\r\"]|\\{WHITE_SPACE_CHAR}+\\)*
COMMENT_TEXT=([^*/\n]|[^*\n]"("[^*\n]|[^/\n]"*"[^/\n]|"*"[^/\n]|")"[^*\n])+
Ident = {ALPHA}({ALPHA}|{DIGIT}|_({ALPHA})+)*
EXTENDED_COMMENT = "(*" {COMMENT_TEXT} "*)"
%%

<YYINITIAL> {
  ";" { return (new Yytoken(0,yytext(),yyline,yychar,yychar+1)); }
  "==" { return (new Yytoken(1,yytext(),yyline,yychar,yychar+2)); }
  "+" { return (new Yytoken(2,yytext(),yyline,yychar,yychar+1)); }
  "-" { return (new Yytoken(3,yytext(),yyline,yychar,yychar+1)); }
  "*" { return (new Yytoken(4,yytext(),yyline,yychar,yychar+1)); }
  "/" { return (new Yytoken(5,yytext(),yyline,yychar,yychar+1)); }
  "%" { return (new Yytoken(6,yytext(),yyline,yychar,yychar+1)); }
  "<>" { return (new Yytoken(7,yytext(),yyline,yychar,yychar+2)); }
  "<"  { return (new Yytoken(8,yytext(),yyline,yychar,yychar+1)); }
  "<=" { return (new Yytoken(9,yytext(),yyline,yychar,yychar+2)); }
  ">"  { return (new Yytoken(10,yytext(),yyline,yychar,yychar+1)); }
  ">=" { return (new Yytoken(11,yytext(),yyline,yychar,yychar+2)); }
  "&&"  { return (new Yytoken(12,yytext(),yyline,yychar,yychar+2)); }
  "||"  { return (new Yytoken(13,yytext(),yyline,yychar,yychar+2)); }
  "skip"  { return (new Yytoken(14,yytext(),yyline,yychar,yychar+4)); }
  "write"  { return (new Yytoken(15,yytext(),yyline,yychar,yychar+5)); }
  "then"  { return (new Yytoken(16,yytext(),yyline,yychar,yychar+4)); }
  "read"  { return (new Yytoken(17,yytext(),yyline,yychar,yychar+4)); }
  "while"  { return (new Yytoken(18,yytext(),yyline,yychar,yychar+5)); }
  "do"  { return (new Yytoken(19,yytext(),yyline,yychar,yychar+2)); }
  "if"  { return (new Yytoken(20,yytext(),yyline,yychar,yychar+2)); }
  "else"  { return (new Yytoken(21,yytext(),yyline,yychar,yychar+4)); }
  "**"  { return (new Yytoken(26,yytext(),yyline,yychar,yychar+2)); }
  "(" { br_count++; return (new Yytoken(27,yytext(),yyline,yychar,yychar+1));}
  ")" { br_count--; return (new Yytoken(28,yytext(),yyline,yychar,yychar+1));}

  {NONNEWLINE_WHITE_SPACE_CHAR}+ { }

 "//"{COMMENT_TEXT} {if(filter == false){ String str =  yytext().substring(2,yylength()-1);
                                             return (new Yytoken(29,str,yyline,yychar,yychar+yylength())); } }

  {EXTENDED_COMMENT} {if(filter == false){ String str =  yytext().substring(2,yylength()-2);
                                                                   return (new Yytoken(30,str,yyline,yychar,yychar+yylength())); } }

  \"{STRING_TEXT}\" {
    String str =  yytext().substring(1,yylength()-1);
    return (new Yytoken(22,str,yyline,yychar,yychar+yylength()));
  }

  \"{STRING_TEXT} {
    String str =  yytext().substring(1,yytext().length());
    return (new Yytoken(23,str,yyline,yychar,yychar + str.length()));
  }

  {DIGIT}+ { return (new Yytoken(24,yytext(),yyline,yychar,yychar+yylength())); }

  {Ident} { return (new Yytoken(25,yytext(),yyline,yychar,yychar+yylength())); }
}

<COMMENT> {
  "(*" { comment_count++; }
  "*)" { if (--comment_count == 0) yybegin(YYINITIAL); }

  {COMMENT_TEXT} { }
}


{NEWLINE} { }