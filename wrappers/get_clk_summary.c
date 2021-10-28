#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    setuid(0);

    FILE *fp = popen("cat /sys/kernel/debug/clk/clk_summary", "r");
    if (fp == NULL)
    {
        return 1;
    }
    
    char tmp[256];
    while (fgets(tmp, sizeof(tmp), fp) != NULL)
    {
        fprintf(stdout, "%s", tmp);
    }

    pclose(fp);
    
    return 0;
}
