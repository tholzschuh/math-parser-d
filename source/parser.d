module parser;

import lexer;

struct Parser
{
	this( string expr )
	{
		_lexer = Lexer( expr );
	}

	double parse() 
	{
		return expression();
	}

	@property ref Lexer lexer() pure { return _lexer; }

private:

	double expression()
	{
		auto result = factor();

		if( lexer.empty ) 
			return result;

		auto token = lexer.front;

		while( token.type == TokenType.plus || token.type == TokenType.minus )
		{
			lexer.popFront;

			if( token.type == TokenType.plus )
				result += factor();
			else
				result -= factor();

			if( lexer.empty ) 
				break;

			token = lexer.front;
		}

		return result;
	}

	double factor()
	{
		auto result = number();

		if( lexer.empty )
			return result;

		auto token = lexer.front;

		while( token.type == TokenType.multiply || token.type == TokenType.divide )
		{
			lexer.popFront;

			if( token.type == TokenType.multiply )
				result *= number();
			else
				result /= number();

			if( lexer.empty ) 
				break;

			token = lexer.front;
		}

		return result;
	}

	double number()
	{
		auto token = lexer.next; // lexer.front; lexer.popFront;

		if( token.type == TokenType.number )
			return token.value;
		else if( token.type == TokenType.lparen )
		{
			auto expr = expression();

			if( lexer.front.type != TokenType.rparen )
				throw new ParseException( "Unbalanced paranthesis." );

			lexer.popFront;


			return expr;
		}
		else
		{
			throw new ParseException( "Not a number." );
		}
	}
	
private:
	Lexer _lexer;
}

class ParseException : Exception
{
	this( string msg )
	{
		super( msg );
	}
}