#include<stdio.h>
#include<fcntl.h>
#include<errno.h>
#include<unistd.h>
#include<sys/ioctl.h>

#define BUF_LEN 256

int main(void) {
    int fd = open("/dev/my_cdev", O_RDONLY);

    if (fd < 0) {
        printf("Error number %d", errno);
    }

    unsigned char buf[BUF_LEN] = {0};
    read(fd, buf, BUF_LEN);

    printf("%s\n", buf);
    
    close(fd);
}
