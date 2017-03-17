#include <pthread.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

void *thread_routine(void *arg)
{
	short l_iloop;

	for(l_iloop=0;l_iloop<5;l_iloop++)
		{
			printf("Hello from thread\n");
			sleep(1);
		}

	return NULL;
}

int main()
{
	pthread_t l_thID;
	short l_iloop;

	if(pthread_create(&l_thID,NULL,thread_routine,NULL))
		{
			printf("Error in creating thread\n");
			exit(0);
		}
	else
		{
			for(l_iloop=0;l_iloop<5;l_iloop++)
				{
					printf("Hello from main\n");
					sleep(1);
				}
		}
	pthread_join(l_thID,NULL);
	return 0;
}
