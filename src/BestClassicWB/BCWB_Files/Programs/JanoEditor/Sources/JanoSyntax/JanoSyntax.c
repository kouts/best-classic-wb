/**********************************************************
**                                                       **
**  JanoSyntax.c : Syntax file compiler and manager for  **
**  JanoEditor v1.02 and up. Written by Thierry Pierron  **
**                                                       **
**  Free Software under GNU license.                     **
**                                                       **
**********************************************************/

#include <dos/dos.h>
#include <exec/lists.h>
#include "DFA.h"
#ifdef	UNIX
#include "Unix.h"
#endif

static UBYTE buffer[512];

static STRPTR filename = NULL;
static ULONG  linenum  = 0;

/* Our main Non-Deterministic Finite Automaton */
NDFA  ndfa = NULL;
DFA_t dfa;

STRPTR tokens[] = {
	"case", "begin", "end", "type", "keyword", "directive", "constant", "comment",
	"error",	"special", "TODO", NULL
};

int get_token_index( STRPTR token )
{
	STRPTR * tok, p;
	int      i;

	for( p = token; *p && !isspace(*p); p++ );

	for( tok = tokens, i = 0; *tok; tok++, i++ )
		if( strncmp( token, *tok, p-token ) == 0 ) return i;

	return -1;
}

/*** Skip token and following white spaces (:alpha:)*\s* ***/
STRPTR skip_token( STRPTR tok )
{
	register STRPTR p;

	for( p = tok; *p && !isspace(*p); p++ );
	for(        ; *p &&  isspace(*p); p++ );

	return p;
}

/*** Print a readable string according to error ***/
void print_fault( int regexp_errno )
{
	printf("%s:%d: ", filename, linenum);
	switch( regexp_errno )
	{
		case REGEXP_OK:                puts("Unexpected token found"); break;
		case REGEXP_SYNTAX_ERROR:      puts("syntax error"); break;
		case REGEXP_MEMORY:            puts("out of memory"); break;
		case REGEXP_INVALID_META_POS:  puts("misplaced meta-character (+, *)"); break;
		case REGEXP_PARENTHESIS_ERROR: puts("missing closing parenthesis"); break;
		default:                       puts("unknown fatal error!");
	}
}

/*** Build finite automaton according to regular expression ***/
BOOL register_tokens( NDFA ndfa, STRPTR tok, int type )
{
	STRPTR p, eow;

	/* Unknown type */
	if( type < 3 ) return FALSE;

	/* Extract tokens and build automaton */
	for( p = tok; p && *p; p = eow )
	{
		eow = parse_regular_expression( ndfa, tok, type );

		/* Error while parsing regexp? */
		if( eow == NULL )
			return FALSE;
	}
	return TRUE;
}

void print_ndfa_states( NDFA ndfa )
{
	NDFA_List lst;
	NDFA_Rel  rel;
	UWORD     nb, j;

	for( nb = ndfa->nb_state+1, lst = ndfa->states, j = 0; nb; lst++, nb--, j++ )
		if( lst->list )
		{
			UWORD i;
			for( i = lst->nb_trans, rel = lst->list; i; i--, rel++ )
				printf("%3d %c %3d\n", j, rel->transition ? rel->transition : '-', rel->state);
		}
}

void print_dfa_states( DFA dfa )
{
	DFA_State state = HEAD( dfa );
	int       trash = -1, i = 0, j;

	for( ; ! END_OF_LIST(state); state = STATE_NEXT(state), i++ )
		if( state->state_id == NULL )
		{
			trash = i; break;
		}

	for( state = HEAD(dfa), i = 0; ! END_OF_LIST(state); state = STATE_NEXT(state), i++ )
	{
		if( i == trash )
		{
			printf("%d TRASHCAN\n", i);
			continue;
		}
		else for( j = 32; j < 256; j++ )
		{
			if( j == 127 ) j = 161;
			if( state->trans[j] != trash )
				printf("%d %c %d\n", i, j, state->trans[j]);
		}
		printf("%d ~ %d\n", i, trash);
	}
}

int main( int argc, char * argv[] )
{
	BPTR file;

	if( argc != 2 )
	{
		puts("usage: JanoSyntax <syntaxfile> <output>");
		exit( RETURN_FAIL );
	}

	if( file = Open( filename = argv[1], MODE_OLDFILE ) )
	{
		STRPTR p;

		ndfa = create_ndfa();

		while( FGets(file, buffer, sizeof(buffer) ) )
		{
			int type, is_ok;

			linenum++;
			/* Ignore comment */
			if( buffer[0] == '#' ) continue;

			for( p = buffer; *p && isspace(*p); p++ );

			/* Discard empty lines */
			if( *p == 0 ) continue; is_ok = TRUE;

			switch( type = get_token_index( p ) )
			{
				case 0: break;
				case 1: /* Start of a region */
/*					p = skip_token(p);
					is_ok = register_tokens( ndfa, skip_token(p), type = get_token_index( p ) );
					push_final_state( ndfa, type ); */
					break;
				case 2:
/*					p = skip_token(p);
					if( *p == 0 ) p = "\n";
					is_ok = register_tokens( ndfa, p, pop_final_state( ndfa ) ); */
					break;
				default:
					/* Search for command type */
					is_ok = register_tokens( ndfa, skip_token(p), type );
			}
			/* Error while parsing */
			if( !is_ok )
			{
				print_fault( regexp_errno );
				break;
			}
		}
		Close( file );

		printf("NDFA :\n");
		print_ndfa_states( ndfa );
		printf("%d states\n", ndfa->nb_state);

		if( deterministic_automaton( ndfa, &dfa ) )
		{
			printf("DFA :\n");
			print_dfa_states( &dfa );
			free_dfa( &dfa );
		}

		free_ndfa( ndfa );
	}
	exit( RETURN_OK );
}

