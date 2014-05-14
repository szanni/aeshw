#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>

static int __init aeshw_init(void)
{
	printk(KERN_INFO "Loaded aeshw!\n");
	return 0;
}

static void __exit aeshw_exit(void)
{
	printk(KERN_INFO "Unloaded aeshw!\n");
}

module_init(aeshw_init);
module_exit(aeshw_exit);

MODULE_AUTHOR("Angelo Haller");
MODULE_DESCRIPTION("AES hardware acceleration");
MODULE_LICENSE("Dual BSD/GPL");
