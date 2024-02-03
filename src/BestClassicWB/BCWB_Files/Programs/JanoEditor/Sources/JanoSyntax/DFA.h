/**********************************************************
**                                                       **
**  DFA.h : Deterministic Finite Automaton datatypes for **
**  JanoEditor v1.02 and up. Written by Thierry Pierron  **
**                                                       **
**  Free Software under GNU license.                     **
**                                                       **
**********************************************************/

#ifndef	DFA_H
#define	DFA_H

typedef UWORD        NDFA_State;

#define	INVALID_STATE           ((NDFA_State)-1)

typedef struct
{
	UBYTE      transition;    /* Character read for transition (0 = Epsilon) */
	UBYTE      type;          /* Pad */
	NDFA_State state;         /* State reach */

} * NDFA_Rel;

#define	EPSILON_TRANSITION		0

typedef struct
{
	NDFA_Rel   list;           /* List of relation */
	UWORD      nb_trans;       /* Nb of transtion */
	UWORD      max_trans;
	UBYTE      is_final;       /* Final state */
	UBYTE      flag;

} * NDFA_List;

typedef struct
{
	NDFA_State state1;       /* Start of parenthesis */
	NDFA_State state2;       /* For union */

} Stack, * NDFA_Stack;

typedef struct              /* Non-Deterministic Finite Automaton */
{
	NDFA_List  states;       /* List of states */
	UWORD      nb_state;     /* Statistics */
	UWORD      max_state;    /* Table capacity */

	/* The following fields are for internal management */

	NDFA_Stack stack;        /* Stack of state */
	UWORD      stack_len;    /* Nb. of item */
	UWORD      stack_max;
	Stack      stack_top;    /* Item on the top (0 otherwise) */

	NDFA_Stack group;        /* For region token */
	UWORD      group_len;    /* Nb. of item */
	UWORD      group_max;
	NDFA_State start_state;  /* Where to start attaching regexp */
	NDFA_State last_state;   /* Last final state after regexp parsing */

} NDFA_t, * NDFA;

typedef struct
{
	struct MinNode list;
	NDFA_State *   state_id;
	NDFA_State     trans[ 256 ];
	UBYTE          is_final;

} * DFA_State;

typedef struct MinList  DFA_t, * DFA;   /* Deterministic Finite Automaton */

/* List management facility */
#define	HEAD(list)         ((DFA_State)((list)->mlh_Head))
#define	STATE_NEXT(state)  ((DFA_State)((state)->list.mln_Succ))
#define	STATE_PREV(state)  ((DFA_State)((state)->list.mln_Pred))
#define	END_OF_LIST(state) ((state)->list.mln_Next == NULL)

/* Public functions */
NDFA   create_ndfa ( void );
void   free_ndfa   ( NDFA );
void   free_dfa    ( DFA  );
STRPTR parse_regular_expression ( NDFA, STRPTR, UBYTE );
BOOL   deterministic_automaton  ( NDFA, DFA );
BOOL   normalize_automaton      ( DFA,  DFA );

/** Possible error codes contained in `regexp_errno' */
#define	REGEXP_OK                0
#define	REGEXP_SYNTAX_ERROR      1
#define	REGEXP_MEMORY            2
#define	REGEXP_INVALID_META_POS  3
#define	REGEXP_PARENTHESIS_ERROR 4

extern int regexp_errno;

#endif

