/*************************************************************
**                                                          **
**     DFA.c : Deterministic Finite Automaton functions     **
**     * Normalize DFA to reduce number of states using     **
**       Myhill-Nerod theorem.                              **
**     * Compress DFA table, using Aho-Sethi-Ullman algo.   **
**                                                          **
**     Written by Thierry Pierron                           **
**                                                          **
**     Free Software under GNU license.                     **
**                                                          **
*************************************************************/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/lists.h>

#include "DFA.h"
#ifdef	UNIX
#include "Unix.h"
#endif

int regexp_errno = REGEXP_OK;  /* Global error number */

/*
 * The following function transform regular expressions into
 * Non-Deterministic Finite Automaton (NDFA), using a simple
 * constructive algorithm.
 */
NDFA create_ndfa( void )
{
	return AllocClear( sizeof(NDFA_t) );
}

/*** Add a new state in the automaton ***/
static BOOL add_rel( NDFA ndfa, NDFA_State src, UBYTE ch_trans, NDFA_State dest )
{
	NDFA_List state;
	NDFA_Rel  trans;
	/* Be sure that there are a suffisant pool of states */
	if( src >= ndfa->max_state )
	{
		/* Not enough, increase pool */
		NDFA_List new;
		ndfa->max_state = src + 16;
		new = (APTR) ReallocVec( ndfa->states, ndfa->max_state * sizeof(*ndfa->states) );

		if( new == NULL ) return FALSE;

		ndfa->states = new;
		memset(new + ndfa->nb_state, 0, (ndfa->max_state - ndfa->nb_state) * sizeof(*new));
	}
	if( ndfa->nb_state < src ) ndfa->nb_state = src;
	state = ndfa->states + src;

	/* Add a new transition for this state */
	if( state->nb_trans == state->max_trans )
	{
		/* Adjust size of buffer before */
		NDFA_Rel new;
		state->max_trans += 16;
		new = (APTR) ReallocVec( state->list, state->max_trans * sizeof(*state->list) );

		if( new == NULL ) return FALSE;

		state->list = new;
	}
	trans = state->list + (state->nb_trans ++);
	trans->transition = ch_trans;
	trans->state      = dest;
	return TRUE;
}

/*** Free all memory associated to a NDFA ***/
void free_ndfa( NDFA ndfa )
{
	if( ndfa )
	{
		NDFA_List lst;
		UWORD    nb;

		if( ndfa->stack ) FreeVec( ndfa->stack );

		for( nb = ndfa->nb_state, lst = ndfa->states; nb; lst++, nb-- )
			if( lst->list ) FreeVec( lst->list );

		FreeVec( ndfa );
	}
}

/** Add a state onto the NDFA stack **/
BOOL push_state( NDFA ndfa, NDFA_State state )
{
	if ( ndfa->stack_max <= ndfa->stack_len )
	{
		NDFA_Stack new;
		
		ndfa->stack_max += 10;
		if ( (new = ReallocVec( ndfa->stack, ndfa->stack_len * sizeof(*new) )) )
		{
			ndfa->stack = new;
		}
		else /* Not enough mem */
		{
			regexp_errno = REGEXP_MEMORY;
			return FALSE;
		}
	}
	/* Fill stack top */
	{	NDFA_Stack top = ndfa->stack + ndfa->stack_len;
		top->state1 = state;
		top->state2 = INVALID_STATE;
		ndfa->stack_top = *top;
	}	ndfa->stack_len++;
	return TRUE;
}

/** Remove last stacked state **/
NDFA_State pop_state( NDFA ndfa )
{
	static Stack dummy_stack = {0, INVALID_STATE};
	NDFA_Stack top;

	if( ndfa->stack_len == 0 )
	{
		regexp_errno = REGEXP_PARENTHESIS_ERROR;
		return INVALID_STATE;
	}
	top = &ndfa->stack[ -- ndfa->stack_len ];
	ndfa->stack_top = (ndfa->stack_len > 0 ? top[-1] : dummy_stack);
	return top->state1;
}

/*** Parse special character ***/
static int build_special_case( NDFA ndfa, UBYTE ch, UWORD old_state )
{
	static UBYTE states[] = "0123456789abcdefABCDEF\t\n";
	UWORD * state, length;
	STRPTR  set = states;

	switch( ch )
	{
		case 'o': length = 8;  break;
		case 'd': length = 10; break;
		case 'x': length = 16; break;
		case 'X': length = 22; break;
		case 't': length = 1;  set = states+22; break;
		case 'n': length = 1;  set = states+23; break;
		default:  length = 1;  set = &ch;
	}
	/* Set multiple states at once */
	while( length-- )
		if( !add_rel(ndfa, old_state, *set++, old_state+1) )
			return 0;

	return 1;
}

/*** Alloc ndfa state according to regular expression ***/
STRPTR parse_regular_expression( NDFA ndfa, STRPTR regexp, UBYTE hl_type )
{
	NDFA_State new, prev, star = INVALID_STATE;
	STRPTR     p;

	/* Add a starting epsilon transition for separating each regexp */
	if( !add_rel(ndfa, ndfa->start_state, EPSILON_TRANSITION, prev = ndfa->last_state+1) )
		return NULL;
	new = prev + 1;

	/* This is the core of token recognition */
	for ( p = regexp; *p; p++ )
	{
		switch( *p )
		{
			case '\\':
				if(p[1] == 0 || build_special_case(ndfa, p[1], new) == 0 )
					return NULL;
				p += 2;
				break;
			case '\n':
			case ' ': p++;    /* break through */
			case 0:   goto big_break;

			/* Meta-characters */
			case '?':
			case '+':
			case '*':
				/* No star should follow the previous character */
				if( star == INVALID_STATE ) {
					regexp_errno = REGEXP_INVALID_META_POS;
					return NULL;
				}
				if( (*p != '?' && !add_rel( ndfa, prev, EPSILON_TRANSITION, star )) ||
				    (*p != '+' && !add_rel( ndfa, star, EPSILON_TRANSITION, prev )) )
					return NULL;
				star = INVALID_STATE;
				break;
			case '|':
				if( ndfa->stack_top.state2 == INVALID_STATE )
				{
					/* No union registered yet */
					ndfa->stack[ ndfa->stack_len-1 ].state2 = 
					ndfa->stack_top.state2 = prev;
				}
				else /* Registered yet, add epsilon transition to merging state */
				{
					if( !add_rel( ndfa, prev, EPSILON_TRANSITION, ndfa->stack_top.state2  ) )
						return NULL;
				}
				star = INVALID_STATE;
				prev = ndfa->stack_top.state1;
				break;
			case '(':
				/* The epsilon transition is required for star */
				if( !add_rel( ndfa, prev, EPSILON_TRANSITION, new ) )
					return NULL;
				prev = new++;
				if( !push_state( ndfa, prev ) )
					return NULL;
				star = INVALID_STATE;
				break;
			case ')':
				/* Add an espilon-transition if there was union regexp */
				if( ndfa->stack_top.state2 != INVALID_STATE )
				{
					NDFA_State state = ndfa->stack_top.state2;
					if( !add_rel( ndfa, prev, EPSILON_TRANSITION, state ) )
						return NULL;

					prev = state;
				}
				star = pop_state( ndfa );
				if( star == INVALID_STATE ) return NULL;
				break;
			/* Standard characters */
			default:
				if( !add_rel( ndfa, prev, *p, new ) )
					return NULL;
				star = prev;
				prev = new++;
		}
	}
	/* Keep track of last state reached */
	big_break:
	ndfa->states[ prev ].is_final = hl_type;
	ndfa->last_state = prev;

	/* We have found a token, restart from beginning now */
	if( hl_type != 0 )
		add_rel( ndfa, prev, EPSILON_TRANSITION, ndfa->start_state );

	return p;
}

/*
 * This part deals with NDFA transformation into Deterministic
 * Finite Automaton (DFA). Deterministic automatons can be processed
 * in a linear time, while non-deterministics need a polynomial
 * time. Sadly, makes an automaton deterministic is an exponential
 * process, and can result in a big amount of state.
 */

/*** Add a state in a vector ***/
static NDFA_State * add_id_state( NDFA_State * id, NDFA_State add_id )
{
	int max, len, i, j;

	if( id )
	{
		len = id[0];
		max = id[1];
	}
	else max = len = 0;

	if( len >= max )
	{
		/* Enlarge state ID */
		max = len + 10;
		id = ReallocVec( id, (max + 2) * sizeof(*id) );
		if( id == NULL ) return NULL;
		id[0] = len;
		id[1] = max;
	}
	/* Sort-insert this state id, discarding duplicate */
	for( i = len + 1; i > 1; i -- )
		if( add_id >= id[i] ) break;
	
	if( 1 < i && add_id == id[i] ) return id;

	/* Insert item at pos i+1, Shift list if not last of the table */
	for( j = len + 2; j > i; j-- )
		id[j] = id[j-1];

	id[0]++; id[i+1] = add_id;

	return id;
}

/*** Compute list of joinable states with epsilon-transition ***/
static NDFA_State * epsilon_closing( NDFA ndfa, NDFA_State state )
{
	NDFA_State * list = add_id_state(NULL, state);
	NDFA_List    trans;
	NDFA_Rel     rel;
	int          nb, i;

	/* Mark states as unvisited */
	for( nb = ndfa->nb_state, trans = ndfa->states; nb >= 0;
	     trans->flag = 0, nb--, trans ++ );

	for( nb = 0; nb < list[0]; nb++ )
	{
		trans = &ndfa->states[ list[nb+2] ];
		rel   = trans->list;

		if( trans->flag == 1 ) continue;
		else trans->flag = 1;

		for( i = trans->nb_trans; i > 0; i --, rel ++ )
			if( rel->transition == EPSILON_TRANSITION )
			{
				list = add_id_state(list, rel->state); nb = -1;
			}
	}
	return list;
}

static BOOL merge_state_id( NDFA_State ** id, NDFA_State * merge )
{
	int length;

	for( length = merge[0]; length > 0; length --, merge++ )
		*id = add_id_state( *id, merge[2] );

	return TRUE;
}

/*** Check if a state already by returning its index ***/
static int state_exists( DFA dfa, NDFA_State * id )
{
	DFA_State state = HEAD(dfa);
	int       index = 0;

	for( ; ! END_OF_LIST(state); state = STATE_NEXT(state), index++ )
	{
		/* NULL id represents the "trashcan" */
		if( id == NULL || state->state_id == NULL )
		{
			if( id == state->state_id ) return index;
			else continue;
		}
		/* Check first if length matches */
		if( id[0] != state->state_id[0] ) continue;

		/* Then content */
		if( memcmp(id+2, state->state_id+2, id[0] * sizeof(id[0])) == 0 )
			return index;
	}
	return -1;
}

/*** Add a new state to the automaton ***/
static DFA_State alloc_state( DFA dfa )
{
	DFA_State new = (APTR) AllocClear( sizeof(*new) );

	if( new )
	{
		AddTail( dfa, &new->list );
	}
	return new;
}

static void print_state( NDFA_State * id, int nb )
{
	printf("State %d = ", nb);
	if( id != NULL )
	{
		for( nb = id[0]; nb; nb--, id++ )
			printf("%d ", id[2]);
	}
	else printf("TRASH");
	printf("\n");
}

/*** Determinize a non-deterministic automaton ***/
BOOL deterministic_automaton( NDFA ndfa, DFA dfa )
{
	DFA_State    state;
	NDFA_State * id;
	int          i, j, nb_state = 1, processed_state = 0;

	NewList( dfa );

	/* Initial state of DFA is the epsilon closing of NDFA's init state */
	state = alloc_state( dfa );
	state->state_id = epsilon_closing( ndfa, 0 );

	print_state( state->state_id, 0 );

	do {
		static NDFA_State * Sigma[ 256 ];

		memset( Sigma, 0, sizeof(Sigma) );

		/* This is the trash state, no need to process it */
		if( state->state_id == NULL ) goto next_state;

		/*
		 * This is the heart of deterministic process. For each state of
		 * the DFA, computes which states can be reach by epsilon closing
		 * in the *NDFA*. Then create states that don't exist yet, or link
		 * to the existing states. Process until no more state are added.
		 * Sadly, this is an exponential algorithm.
		 */
		for( id = state->state_id+2, j = id[-2]; j > 0; j--, id++ )
		{
			NDFA_List s = &ndfa->states[ *id ];
			NDFA_Rel  r = s->list;

			for( i = 0; i < s->nb_trans; i++, r++ )
				if( r->transition != EPSILON_TRANSITION )
					merge_state_id( Sigma + r->transition, epsilon_closing(ndfa, r->state) );
		}

		/*
		 * Now we have the states reached by each character for the current
		 * state. Add missing states, or link to the existing one otherwise.
		 */
		for( i = 0; i < 256; i++ )
		{
			NDFA_State * p = &state->trans[i];
			int          n = state_exists( dfa, Sigma[i] );

			if( n != -1 )
			{
				*p = n;
				FreeVec( Sigma[i] );
			}
			else /* State doesn't exists yet, creates it */
			{
				DFA_State s = alloc_state( dfa );
				*p = nb_state++;
				s->state_id = Sigma[i];
				print_state(Sigma[i], nb_state-1);
			}
		}
		/* Process next state */
		next_state: state = STATE_NEXT( state ); processed_state++;
	}
	while( processed_state < nb_state );
	return TRUE;
}

/*** Free ressources allocated for an DFA ***/
void free_dfa( DFA dfa )
{
	DFA_State state = HEAD( dfa ), next;

	for( ; ! END_OF_LIST(state); state = next )
	{
		next = STATE_NEXT( state );
		if( state->state_id ) FreeVec( state->state_id );
		FreeVec( state );
	}
}

