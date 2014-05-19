#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <crypto/algapi.h>
#include <crypto/aes.h>

struct aeshw_ctx {
};

static int aeshw_ecb_setkey(struct crypto_tfm *tfm, const u8 *in_key,
			    unsigned int key_len)
{
	printk(KERN_INFO "Set ecb key in aeshw!\n");
	return 0;
}

static int aeshw_ecb_encrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	printk(KERN_INFO "Encrypt ecb in aeshw!\n");
	return 0;
}

static int aeshw_ecb_decrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	printk(KERN_INFO "Decrypt ecb in aeshw!\n");
	return 0;
}

static struct crypto_alg aeshw_ecb_alg = {
	.cra_name		=	"ecb(aes)",
	.cra_driver_name	=	"aeshw-ecb",
	.cra_priority		=	1,
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

static int aeshw_cbc_setkey(struct crypto_tfm *tfm, const u8 *in_key,
			    unsigned int key_len)
{
	printk(KERN_INFO "Set cbc key in aeshw!\n");
	return 0;
}

static int aeshw_cbc_encrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	//struct aeshw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
	struct blkcipher_walk walk;
	int rv;

	printk(KERN_INFO "Encrypt cbc in aeshw!\n");

	blkcipher_walk_init(&walk, dst, src, nbytes);
	rv = blkcipher_walk_virt(desc, &walk);

	while ((nbytes = walk.nbytes)) {
		memcpy(walk.dst.virt.addr, walk.src.virt.addr, nbytes);
		nbytes -= nbytes;
		rv = blkcipher_walk_done(desc, &walk, nbytes);
	}

	return rv;
}

static int aeshw_cbc_decrypt(struct blkcipher_desc *desc,
			     struct scatterlist *dst, struct scatterlist *src,
			     unsigned int nbytes)
{
	printk(KERN_INFO "Decrypt cbc in aeshw!\n");
	return 0;
}

static struct crypto_alg aeshw_cbc_alg = {
	.cra_name		=	"cbc(aes)",
	.cra_driver_name	=	"aeshw-cbc",
	.cra_priority		=	1,
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
			.setkey	   		= 	aeshw_cbc_setkey,
			.encrypt		=	aeshw_cbc_encrypt,
			.decrypt		=	aeshw_cbc_decrypt,
			.ivsize	   		= 	AES_BLOCK_SIZE,
		}
	}
};

static int __init aeshw_init(void)
{
	int rv = 0;

	if ((rv = crypto_register_alg(&aeshw_ecb_alg)))
		goto err;

	if ((rv = crypto_register_alg(&aeshw_cbc_alg)))
		goto err_unregister_ecb;

	printk(KERN_INFO "Loaded aeshw!\n");
	return rv;

err_unregister_ecb:
	crypto_unregister_alg(&aeshw_ecb_alg);

err:
	printk(KERN_ERR "Failed to load aeshw!\n");
	return rv;
}

static void __exit aeshw_exit(void)
{
	crypto_unregister_alg(&aeshw_cbc_alg);
	crypto_unregister_alg(&aeshw_ecb_alg);

	printk(KERN_INFO "Unloaded aeshw!\n");
}

module_init(aeshw_init);
module_exit(aeshw_exit);

MODULE_AUTHOR("Angelo Haller");
MODULE_DESCRIPTION("AES hardware acceleration");
MODULE_LICENSE("Dual BSD/GPL");

