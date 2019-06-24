# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.


configfile: "config.yaml"
include: "rules/common.smk"

rule all:
    input:
        Prefix + "CountTableNumerators.gz",
        expand(Prefix + "SnaptronMetadata.{snapdb}.txt.gz", snapdb=snaptron_samples.index),
        "logs/delete_temp_files/{Samples_TargetJunctions}.log".format(Samples_TargetJunctions=Samples_TargetJunctions),
        "leafcutter/differential_splicing/{leafcutter_outprefix}_effect_sizes.txt".format(leafcutter_outprefix = leafcutter_ds_outprefix),
    output:
        Prefix + "GatherFilesCopied.log"
    shell:
        """
        echo `date` >> {output}
        echo {input} >> {output}
        """

include: "rules/GetDataForLeafcutter.smk"
include: "rules/leafcutter.smk"
include: "rules/other.smk"
include: "rules/MoveOutputForGitRepo.smk"
