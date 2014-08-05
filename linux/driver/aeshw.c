#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <crypto/algapi.h>
#include <crypto/aes.h>
#include <asm/io.h>
#include <linux/of_platform.h>

enum AES_MODE {
	AES_MODE_ENCRYPT = 0x00000000,
	AES_MODE_DECRYPT = 0x01010101,
	AES_MODE_SET_KEY = 0x02020202
};

enum OFFSET {
	OFFSET_DIN  = 0x0,
	OFFSET_DOUT = 0x10,
	OFFSET_CTL  = 0x20,
	OFFSET_STAT = 0x24,
};

unsigned long remap_size;
unsigned long phys_addr;
unsigned long *virt_addr;

void aeshw_write(const void *src, enum AES_MODE mode)
{
	memcpy_toio((u8*)virt_addr + OFFSET_DIN, src, AES_BLOCK_SIZE);
	iowrite32(mode, (u8*)virt_addr + OFFSET_CTL);

	while (ioread32((u8*)virt_addr + OFFSET_STAT) == 0) {
		//idle
	}
}

void aeshw_xor_inplace(const void *dst, const void *src)
{
	int i;

	for (i = 0; i < 4; ++i)
		*((u32*)dst + i) ^= *((u32*)src + i);
}

void aeshw_read(void *dst)
{
	memcpy_fromio(dst, (u8*)virt_addr + OFFSET_DOUT, AES_BLOCK_SIZE);
}

static int aeshw_setkey(struct crypto_tfm *tfm, const u8 *in_key,
			    unsigned int key_len)
{
	printk(KERN_INFO "Set key in aeshw!\n");

	aeshw_write(in_key, AES_MODE_SET_KEY);

	return 0;
}

static int aeshw_ecb_encrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	int rv;
	struct blkcipher_walk walk;

	printk(KERN_INFO "Encrypt ecb in aeshw!\n");

	blkcipher_walk_init(&walk, dst, src, nbytes);
	rv = blkcipher_walk_virt(desc, &walk);

	while ((walk.nbytes)) {
		aeshw_write(walk.src.virt.addr, AES_MODE_ENCRYPT);
		aeshw_read(walk.dst.virt.addr);

		rv = blkcipher_walk_done(desc, &walk, walk.nbytes - AES_BLOCK_SIZE);
	}

	return rv;
}

static int aeshw_ecb_decrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	int rv;
	struct blkcipher_walk walk;

	printk(KERN_INFO "Decrypt ecb in aeshw!\n");

	blkcipher_walk_init(&walk, dst, src, nbytes);
	rv = blkcipher_walk_virt(desc, &walk);

	while ((walk.nbytes)) {
		aeshw_write(walk.src.virt.addr, AES_MODE_DECRYPT);
		aeshw_read(walk.dst.virt.addr);

		rv = blkcipher_walk_done(desc, &walk, walk.nbytes - AES_BLOCK_SIZE);
	}

	return rv;
}

static struct crypto_alg aeshw_ecb_alg = {
	.cra_name		=	"ecb(aes)",
	.cra_driver_name	=	"aeshw-ecb",
	.cra_priority		=	100,
	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
	.cra_blocksize		=	AES_BLOCK_SIZE,
	.cra_type		=	&crypto_blkcipher_type,
	.cra_module		=	THIS_MODULE,
	.cra_u			=	{
		.blkcipher = {
			.min_keysize		=	AES_KEYSIZE_128,
			.max_keysize		=	AES_KEYSIZE_128,
			.setkey	   		= 	aeshw_setkey,
			.encrypt		=	aeshw_ecb_encrypt,
			.decrypt		=	aeshw_ecb_decrypt,
		}
	}
};

static int aeshw_cbc_encrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{

	int rv;
	struct blkcipher_walk walk;

	printk(KERN_INFO "Encrypt cbc in aeshw!\n");

	blkcipher_walk_init(&walk, dst, src, nbytes);
	rv = blkcipher_walk_virt(desc, &walk);

	while ((walk.nbytes)) {
		aeshw_xor_inplace(walk.src.virt.addr, walk.iv);
		aeshw_write(walk.src.virt.addr, AES_MODE_ENCRYPT);
		aeshw_read(walk.dst.virt.addr);
		memcpy(walk.iv, walk.dst.virt.addr, AES_BLOCK_SIZE);

		rv = blkcipher_walk_done(desc, &walk, walk.nbytes - AES_BLOCK_SIZE);
	}

	return rv;
}

static int aeshw_cbc_decrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	int rv;
	struct blkcipher_walk walk;

	printk(KERN_INFO "Decrypt cbc in aeshw!\n");

	blkcipher_walk_init(&walk, dst, src, nbytes);
	rv = blkcipher_walk_virt(desc, &walk);

	while ((walk.nbytes)) {
		aeshw_write(walk.src.virt.addr, AES_MODE_DECRYPT);
		aeshw_read(walk.dst.virt.addr);
		aeshw_xor_inplace(walk.dst.virt.addr, walk.iv);
		memcpy(walk.iv, walk.src.virt.addr, AES_BLOCK_SIZE);

		rv = blkcipher_walk_done(desc, &walk, walk.nbytes - AES_BLOCK_SIZE);
	}

	return rv;
}

static struct crypto_alg aeshw_cbc_alg = {
	.cra_name		=	"cbc(aes)",
	.cra_driver_name	=	"aeshw-cbc",
	.cra_priority		=	100,
	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
	.cra_blocksize		=	AES_BLOCK_SIZE,
	.cra_type		=	&crypto_blkcipher_type,
	.cra_module		=	THIS_MODULE,
	.cra_u			=	{
		.blkcipher = {
			.min_keysize		=	AES_KEYSIZE_128,
			.max_keysize		=	AES_KEYSIZE_128,
			.ivsize	   		= 	AES_BLOCK_SIZE,
			.setkey	   		= 	aeshw_setkey,
			.encrypt		=	aeshw_cbc_encrypt,
			.decrypt		=	aeshw_cbc_decrypt,
		}
	}
};


static int aeshw_probe(struct platform_device *pdev)
{
	int rv = 0;
	struct resource *res;

	if ((rv = crypto_register_alg(&aeshw_ecb_alg)))
		goto err;

	if ((rv = crypto_register_alg(&aeshw_cbc_alg)))
		goto err_unregister_ecb;

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (res == NULL) {
		dev_err(&pdev->dev, "No memory resource\n");
		rv = -ENODEV;
		goto err_unregister_cbc;
	}

	remap_size = res->end - res->start + 1;
	remap_size = 512;
	phys_addr = res->start;
	if (request_mem_region(phys_addr, remap_size, pdev->name) == NULL) {
		dev_err(&pdev->dev, "Cannot request IO\n");
		rv = -ENXIO;
		goto err_unregister_cbc;
	}

	virt_addr = ioremap_nocache(phys_addr, remap_size);
	if (virt_addr == NULL) {
		dev_err(&pdev->dev, "Cannot ioremap memory at 0x%08lx\n", phys_addr);
		rv = -ENOMEM;
		goto err_release_mem;
	}

	printk(KERN_INFO "Probed aeshw device!\n");
	return rv;

err_release_mem:
	release_mem_region(phys_addr, remap_size);

err_unregister_cbc:
	crypto_unregister_alg(&aeshw_cbc_alg);

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
	crypto_unregister_alg(&aeshw_cbc_alg);
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

