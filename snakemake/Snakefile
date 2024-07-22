"""
Prototypical workflow for the analysis on data split into many files located in the paths
scratch/{data, mc}/{2012, 2018}/beauty2darkmatter_{i}.root
"""

# global-scope config
configfile: "config/main.yml" # NOTE: colon syntax 
# global-scope variables, fetched from the config file in config/main.yml
years = config["years"] 


rule all: # NOTE: special directive setting the target of the workflow
    """
    Target of the workflow; this sets up the direct acyclic graph (DAG) of the workflow
    """
    input:
        expand("scratch/{filetype}/{year}/post_processed/beauty2darkmatter_{i}.root", 
        filetype=["data", "mc"], year=years, i=range(3))


rule select:
    """First step of the analysis: select events"""
    input:
        "scratch/{filetype}/{year}/beauty2darkmatter_{i}.root"
    output:
        "scratch/{filetype}/{year}/selected/beauty2darkmatter_{i}.root"
    shell:
        "python src/process.py --input {input} --output {output}"


rule post_process:
    """Second step of the analysis: post-process selected events"""
    input:
        "scratch/{filetype}/{year}/selected/beauty2darkmatter_{i}.root"
    output:
        "scratch/{filetype}/{year}/post_processed/beauty2darkmatter_{i}.root"
    shell:
        "python src/process.py --input {input} --output {output}"     