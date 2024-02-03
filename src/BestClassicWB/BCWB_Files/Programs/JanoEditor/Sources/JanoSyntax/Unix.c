
#include <exec/lists.h>
#include "Unix.h"

void AddTail( struct MinList * header, struct MinNode * node )
{
	node->mln_Succ = NULL;
	if( (node->mln_Pred = header->mlh_Tail) )
		header->mlh_Tail->mln_Succ = node;
	else
		header->mlh_Head = node;
	header->mlh_Tail = node;
}

