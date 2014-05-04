module token;

import std.conv : to;
import std.string : isNumeric;

enum TokenType
{
	plus, // +
	minus, // -
	multiply, // *
	divide, // /
	
	lparen, // (
	rparen, // )
	
	number, // x

	skip, // ' '
	end // END
}

struct Token
{
	private alias Type = TokenType;

	this( Type type )
	{
		this.type = type;
	}

	this( double value )
	{
		type = TokenType.number;
		this.value = value;
	}

	this( string value )
	{
		assert( value.isNumeric );
		this( to!double(value) );
	}

	@property auto type() pure const { return _type; }
	@property auto type( in Type t ) { _type = t; }

	@property auto value() pure const
	{
		if( !type == TokenType.number )
			throw new Exception( ".. not a number." );

		return _value;
	}
	@property void value( in double value ) { _value = value; }

	string toString() const
	{
		if( type == Type.number )
			return to!string( value );
		else
			return to!string( type );
	}

private:
	Type _type;
	double _value;
}
