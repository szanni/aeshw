#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <crypto/algapi.h>
#include <crypto/aes.h>
#include <asm/io.h>
#include <linux/of_platform.h>

#define OFFSET_DIN  0x0
#define OFFSET_DOUT 0x10
#define OFFSET_CTL  0x20
#define OFFSET_STAT 0x24

unsigned long remap_size;
unsigned long phys_addr;
unsigned long *virt_addr;

struct aeshw_ctx {
};

static int aeshw_ecb_setkey(struct crypto_tfm *tfm, const u8 *in_key,
			    unsigned int key_len)
{
	u32 mode = 0x02020202;
	iowrite32_rep((u8*)virt_addr + OFFSET_DIN, in_key, 4);
	iowrite32(mode, (u8*)virt_addr + OFFSET_CTL);
	while (ioread32((u8*)virt_addr + OFFSET_STAT) == 0) {
		//idle
	}

	return 0;
}

static int aeshw_ecb_encrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	int rv;
	u32 mode = 0x0;
	struct blkcipher_walk walk;

	//printk(KERN_INFO "Encrypt ecb in aeshw!\n");

	blkcipher_walk_init(&walk, dst, src, nbytes);
	rv = blkcipher_walk_virt_block(desc, &walk, 16);

	while ((nbytes = walk.nbytes)) {
		iowrite32_rep((u8*)virt_addr + OFFSET_DIN, walk.src.virt.addr, 4);
		iowrite32(mode, (u8*)virt_addr + OFFSET_CTL);

		while (ioread32((u8*)virt_addr + OFFSET_STAT) == 0) {
			//idle
		}

		ioread32_rep((u8*)virt_addr + OFFSET_DOUT, walk.dst.virt.addr, 4);

		nbytes -= nbytes;
		rv = blkcipher_walk_done(desc, &walk, nbytes);
	}

	return rv;
}

static int aeshw_ecb_decrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	//printk(KERN_INFO "Decrypt ecb in aeshw!\n");
	return 0;
}

static struct crypto_alg aeshw_ecb_alg = {
	.cra_name		=	"ecb(aes)",
	.cra_driver_name	=	"aeshw-ecb",
	.cra_priority		=	100,
	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
	.cra_blocksize		=	AES_BLOCK_SIZE,
	.cra_ctxsize		=	sizeof(struct aeshw_ctx),
	.cra_alignmask		=	0,
	.cra_type		=	&crypto_blkcipher_type,
	.cra_module		=	THIS_MODULE,
	.cra_u			=	{
		.blkcipher = {
			.min_keysize		=	AES_MIN_KEY_SIZE,
			.max_keysize		=	AES_MAX_KEY_SIZE,
			.setkey	   		= 	aeshw_ecb_setkey,
			.encrypt		=	aeshw_ecb_encrypt,
			.decrypt		=	aeshw_ecb_decrypt,
		}
	}
};

static int aeshw_probe(struct platform_device *pdev)
{
	int rv = 0;
	struct resource *res;

	if ((rv = crypto_register_alg(&aeshw_ecb_alg)))
		goto err;

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (res == NULL) {
		dev_err(&pdev->dev, "No memory resource\n");
		rv = -ENODEV;
		goto err_unregister_ecb;
	}

	remap_size = res->end - res->start + 1;
	remap_size = 512;
	phys_addr = res->start;
	if (request_mem_region(phys_addr, remap_size, pdev->name) == NULL) {
		dev_err(&pdev->dev, "Cannot request IO\n");
		rv = -ENXIO;
		goto err_unregister_ecb;
	}

	virt_addr = ioremap_nocache(phys_addr, remap_size);
	if (virt_addr == NULL) {
		dev_err(&pdev->dev, "Cannot ioremap memory at 0x%08lx\n",
			(unsigned long)phys_addr);
		rv = -ENOMEM;
		goto err_release_mem;
	}

	printk(KERN_INFO "Probed aeshw device!\n");
	return rv;

err_release_mem:
	release_mem_region(phys_addr, remap_size);

err_unregister_ecb:
	crypto_unregister_alg(&aeshw_ecb_alg);

err:
	dev_err(&pdev->dev, "Failed to initialize device\n");
	return rv;
}

static int aeshw_remove(struct platform_device *pdev)
{
	iounmap(virt_addr);
	release_mem_region(phys_addr, remap_size);
	crypto_unregister_alg(&aeshw_ecb_alg);
	printk(KERN_INFO "Removed aeshw device!\n");
	return 0;
}

static struct of_device_id aeshw_of_match[] = {
	{ .compatible = "aeshw,aeshw-1.00.a", },
	{}
};

MODULE_DEVICE_TABLE(of, aeshw_of_match);

static struct platform_driver aeshw_platform_driver = {
	.probe = aeshw_probe,
	.remove = aeshw_remove,
	.driver = {
		.name = "aeshw",
		.owner = THIS_MODULE,
		.of_match_table = of_match_ptr(aeshw_of_match),
	},
};

module_platform_driver(aeshw_platform_driver);

MODULE_AUTHOR("Angelo Haller");
MODULE_DESCRIPTION("AES hardware acceleration");
MODULE_LICENSE("Dual BSD/GPL");

