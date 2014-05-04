module lexer;

public import token;
import std.conv : to;

struct Lexer
{
	this( string expr )
	{
		this.expr = expr;
	}

	Token token( in char c )
	{
		switch( c )
		{
			case '+':
				return Token( TokenType.plus );
			case '-':
				return Token( TokenType.minus );
			case '*':
				return Token( TokenType.multiply );
			case '/':
				return Token( TokenType.divide );
			case '(':
				return Token( TokenType.lparen );
			case ')':
				return Token( TokenType.rparen );
			case ' ':
				return Token( TokenType.skip );
			default:
				return Token( cast(double)( c - '0' ) );
		}
	}

	@property Token next()
	{
		auto token = front();

		if( token.type != TokenType.end )
			popFront();

		return token;
	}

	@property Token front() 
	{ 
		if( index == expr.length )
		{
			++_index; // empty == true
			return Token( TokenType.end ); // End-Token
		}
		else if( empty )
				throw new LexerException( "No more tokens." );



		auto tok = token( expr[index] );

		if( tok.type == TokenType.number )
		{
			size_t i = 1;

			string val = "" ~ expr[index];

			while( index + i < expr.length && token( expr[index+i]).type == TokenType.number )
			{
				val ~= to!string( expr[index+i] );
				i++;
			}

			_index += i -1;

			tok = Token( val );
		}

		return tok;
	}

	auto lexy(  size_t begin = 0 )
	in {
		assert( begin >= 0 && begin < expr.length );
	}
	body {
		Token[] tokens;

		foreach( i; begin..expr.length )
		{
			tokens ~= token( expr[i] );
		}

		tokens ~= Token( TokenType.end );

		return tokens;
	}

	void popFront() { ++_index; }
	@property bool empty() { return (index > expr.length); }

	@property auto expr() pure const { return _expr; }
	@property auto expr( in string expr ) { _expr = expr; }

	@property auto index() pure const { return _index; }
	@property auto index( in size_t index ) { _index = index; }

	

private:
	string _expr;
	size_t _index = 0;
}

class LexerException : Exception
{
	this( string msg )
	{
		super( msg );
	}
}

