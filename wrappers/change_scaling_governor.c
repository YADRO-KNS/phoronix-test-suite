#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

void usage()
{
    fprintf(stdout, "Usage: change_scaling_governor [mode] [cpu_num] \n\n\
change_scaling_governor performance 1 - change scaling_governor mode to \"performance\" for cpu1\n");
}

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        usage();
        return 1;
    }

    char cmd[128];

    setuid(0);
    snprintf(cmd, 128, "echo %s > /sys/devices/system/cpu/cpu%s/cpufreq/scaling_governor", argv[1], argv[2]);
    system(cmd);

    return 0;
}
