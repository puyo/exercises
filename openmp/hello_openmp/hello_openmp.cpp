#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
#include "omp.h"

using namespace std;

//****************************************************************************80
//
//  Purpose:
//
//    HELLO has each thread print out its ID.
//
//  Discussion:
//
//    HELLO is a "Hello, World" program for OpenMP.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    19 May 2010
//
//  Author:
//
//    John Burkardt
//
int main(int argc, char *argv[]) {
  int id;
  double wtime;

  cout << "  Number of processors available = " << omp_get_num_procs() << "\n";
  cout << "  Number of threads =              " << omp_get_max_threads() << "\n";

  wtime = omp_get_wtime();

  # pragma omp parallel \
  private ( id )
  {
    id = omp_get_thread_num();

    ostringstream s;
    s << "  This is process ";
    s << std::setfill('0') << std::setw(8) << id;
    s << "\n";
    cout << s.str();
  }

  wtime = omp_get_wtime() - wtime;

  cout << "\n";
  cout << "HELLO_OPENMP\n";
  cout << "  Normal end of execution.\n";

  cout << "\n";
  cout << "  Elapsed wall clock time = " << wtime << "\n";

  return 0;
}
