#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/time.h>
#include <linux/uaccess.h>

MODULE_AUTHOR("Tsurkan");
MODULE_DESCRIPTION("Simple char device module");
MODULE_LICENSE("GPL");

#define BUF_LEN 256


#define MSG_PREF "MSG: "
#define print_msg(msg, ...) printk(KERN_ERR MSG_PREF msg, ##__VA_ARGS__);

// структуры ядра необходимые для создания символьного драйвера
dev_t devt = 0;
static struct class *dev_class = NULL;
static struct cdev my_cdev;
static struct device *dev = NULL;

static int cntr=0;
static int      my_open(struct inode *inode, struct file *file);
static int      my_release(struct inode *inode, struct file *file);
static ssize_t  my_read(struct file *filp, char __user *buf, size_t len,loff_t * off);
static ssize_t  my_write(struct file *filp, const char *buf, size_t len, loff_t * off);
static long 	my_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);

// структура ядра содержащая указатели на реализации операций для нашего девайса
static struct file_operations fops = {
    .owner      	= THIS_MODULE,
    .read       	= my_read,
    .write      	= my_write,
    .open       	= my_open,
    .release    	= my_release,
    .unlocked_ioctl = my_ioctl,
};

static int my_open(struct inode *inode, struct file *file)
{
	print_msg("Driver Open Function Called...!!!\n");
	return 0;
}

static int my_release(struct inode *inode, struct file *file)
{
	print_msg("Driver Release Function Called...!!!\n");
	return 0;
}

static ssize_t my_read(struct file *filp, char __user *buf, size_t len, loff_t *off)
{
	uint8_t data[BUF_LEN] = {0};
	print_msg("Driver Read Function Called...!!!\n");

	//my func
	cntr=cntr+1;
	
	snprintf(data, BUF_LEN, "Counter: %i", cntr);

	if (len > BUF_LEN) {
		len = BUF_LEN;
	}

	// функция для безхопасного копиования данных из области ядра в область пользователя
	if (copy_to_user(buf, data, len)) {
		return -EFAULT;
	}

	return len;
}

static ssize_t my_write(struct file *filp, const char __user *buf, size_t len, loff_t *off)
{
	print_msg("Driver Write Function Called...!!!\n");
	return len;
}

static long my_ioctl(struct file *filp, unsigned int cmd, unsigned long arg) {
	print_msg("Driver Ioctl Function Called...!!!\n");
	return 0;
}

static int __init cdev_module_init(void)
{
	long res = 0;
	// выделяем область chardev и назначаем Major номер
	if((res = alloc_chrdev_region(&devt, 0, 1, "my_cdev")) < 0){
		print_msg("Cannot allocate major number\n");
		goto alloc_err;
	}
	// инициализируем новое устройство
	cdev_init(&my_cdev, &fops);
	// добавляем устройство в систему
	if((res = cdev_add(&my_cdev, devt, 1)) < 0){
		print_msg("Cannot add the device to the system\n");
		goto cdev_add_err;
	}

	// создаем класс sysfs
	dev_class = class_create(THIS_MODULE, "my_class");
	// обработка ошибок
	if(IS_ERR(dev_class)){
		res = PTR_ERR(dev_class);
		print_msg("Cannot create the struct class\n");
		goto class_err;
	}

	// создаем узел устройства /dev/my_cdev
	dev = device_create(dev_class, NULL, devt, NULL, "my_cdev");
	// обработка ошибок
	if(IS_ERR(dev)){
		res = PTR_ERR(dev);
		print_msg("Cannot create the Device\n");
		goto dev_create_err;
	}

	print_msg("Device Driver Insert...Done!!!\n");
	return 0;
dev_create_err:
	class_destroy(dev_class);
class_err:
cdev_add_err:
	unregister_chrdev_region(devt, 1);
alloc_err:
	return res;
}

static void __exit cdev_module_exit(void)
{
	device_destroy(dev_class, devt);
	class_destroy(dev_class);
	cdev_del(&my_cdev);
	unregister_chrdev_region(devt, 1);
	print_msg("Device Driver Remove...Done!!!\n");
}
module_init(cdev_module_init);
module_exit(cdev_module_exit);
