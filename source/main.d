module main;

import std.stdio : writeln, readln, write;
import std.string : chomp;

import parser;

void main( string[] args )
{
	Parser parser;
	string expr;

	if( args.length > 2 )
		throw new Exception( "Only 2 arguments expected." );
	else if( args.length == 2 )
	{
		expr = args[1];
	}
	else
	{
		writeln( "Expression: " );
		expr = chomp( readln() );
	}

	parser = Parser( expr );

	writeln( expr, " = ", parser.parse );
}
