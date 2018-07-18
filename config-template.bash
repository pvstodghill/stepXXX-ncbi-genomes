# Genomes are downloaded using the `download_genomes` function. This
# function takes a list of NCBI assembly accessions, downloads the
# associated files, and unpacks them in the `results` dir. E.g.,
#
#     # Downloads the DC3000 genome from RefSeq (e.g., NC_004578.*,
#     # etc.) to `results/`
#     download_genomes GCF_000007805.1
#
# Multiple accessions may be specified when the function is invoked. E.g.,
#
#     # Downloads the DC3000 genome from RefSeq and GENBANK (e.g., `NC_004578.*`,
#     # etc. and `AE016853.*`, etc.) to `results/`
#     download_genomes GCA_000007805.1 GCF_000007805.1
#
# Instead of writing all of the files to `results/`, `-d DIR` can be
# specified in the function invocation, and the results will be
# written to `results/DIR` instead. This is helpful when downloading
# genomes from multiple organisms for analysis. E.g.,
#
#     download_genomes -d Pseudomonas_syringae_tomato_DC3000 GCA_000007805.1 GCF_000007805.1
#     download_genomes -d Escherichia_coli_K-12_MG1655 GCA_000005845.2 GCF_000005845.2
#     download_genomes -d Pantoea_ananatis_LMG_20103 GCF_000025405.2 GCA_000025405.2
#     download_genomes -d Clavibacter_michiganensis_michiganensis_NCPPB382 GCF_000063485.1 GCA_000063485.1

