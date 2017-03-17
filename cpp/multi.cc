#include <stdio.h>

/*
 gameobj { monster -> monster_elf } player_elf
         { player     player      }
*/


class GAMEOBJ
{
};


class MONSTER : public GAMEOBJ
{
};


class MONSTER_ELF : public MONSTER
{
public:
 virtual char * description() { return "elf"; }
};



class PLAYER : public GAMEOBJ
{
 // things about players which are extensions/different to monsters
public:
 virtual char * description() { return "?"; }
};


class PLAYER_ELF : public MONSTER_ELF, public PLAYER
{
public:
 //virtual char * description() { return ""; }
};





int main(void)
{
 PLAYER * p;

 p = new PLAYER_ELF;

 printf("\n----------\n");
 printf("You are a(n) %s.", p->description());
 printf("\n");

 delete p;

 return 0;
}
