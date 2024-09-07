#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

void handle_signal(int signal) {
  time_t start;
  time_t end;
  double elapsed;
  
  switch (signal) {
    case SIGTERM:
      time(&start);
      printf("SIGTERM received. Continuing...\n");
      while (1) {
        time(&end);
        elapsed = difftime(end, start);
        printf("    Elapsed %i second(s)\n", (int)elapsed);
        sleep(1);
      }
      break;
    case SIGINT:
      printf("\n'Ctrl+C' received. Continuing...\n");
      break;
    case SIGQUIT:
      printf("\n'Ctrl+\\' received. Closing...\n");
      exit(0);
    default:
      printf("Unknown(%i) received. Continuing...\n", signal);
      break;
  }
}

int main(void) {
  signal(SIGINT, handle_signal);
  signal(SIGTERM, handle_signal);
  signal(SIGQUIT, handle_signal);
  setbuf(stdout, NULL);

  printf("Signal handling started...\n");
  while (1) {
    sleep(1);
  }
  return 0;
}
