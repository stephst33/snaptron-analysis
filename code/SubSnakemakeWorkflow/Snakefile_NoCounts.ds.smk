# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.


configfile: "config.yaml"
include: "rules/common.smk"

rule all:
    input:
        #Prefix + "CountTableNumerators.gz",
        #expand(Prefix + "SnaptronMetadata.{snapdb}.txt.gz", snapdb=snaptron_samples.index),
        # "logs/delete_temp_files/{Samples_TargetJunctions}.log".format(Samples_TargetJunctions=Samples_TargetJunctions),
        Prefix + "leafcutter.ds.effect_sizes.txt.gz",
        "leafcutter/clustering/{Samples_TargetJunctions}/Merged/leafcutter_perind.counts.numers.gz".format(Samples_TargetJunctions = Samples_TargetJunctions),
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
