#include <iostream>
#include <fstream.h>
#include <string>


void write(ofstream& la, const char * s)
{
 throw static_cast <string> ("Ouch!");

 if (!la.is_open()) throw static_cast <string> ("File could not be opened!");

 la << s;
}


int main(void)
{
 ofstream f;

 f.open("out.txt", 1);

 try
 {
  write(f, "Output!!");
 }
 catch (string& s)
 {
  cerr << s;
 }

 f.close();
}

