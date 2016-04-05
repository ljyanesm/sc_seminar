#!/bin/bash
# Put your SLURM options here
#SBATCH --time=00:15:00			# put proper time of reservation here
#SBATCH --ntasks-per-node=1		# processes per node
#SBATCH -c 1
#SBATCH --mem=3G			# memory resource
#SBATCH --job-name="seq_job"		# change to your job name
#SBATCH --output=dmtcp.out		# change to proper file name or remove for defaults
# ? Any other batch options ?

#----------------------------- Set up DMTCP environment for a job ------------#
###############################################################################
# Start DMTCP coordinator on the launching node. Free TCP port is automatically
# allocated.  This function creates a dmtcp_command.$JOBID script, which serves
# as a wrapper around dmtcp_command.  The script tunes dmtcp_command for the
# exact dmtcp_coordinator (its hostname and port).  Instead of typing
# "dmtcp_command -h <coordinator hostname> -p <coordinator port> <command>",
# you just type "dmtcp_command.$JOBID <command>" and talk to the coordinator
# for JOBID job.
###############################################################################

start_coordinator()
{
    ############################################################
    # For debugging when launching a custom coordinator, uncomment 
    # the following lines and provide the proper host and port for 
    # the coordinator.
    ############################################################
    # export DMTCP_COORD_HOST=$h
    # export DMTCP_COORD_PORT=$p
    # return

    fname=dmtcp_command.$SLURM_JOBID
    h=`hostname`

    check_coordinator=`which dmtcp_coordinator`
    if [ -z "$check_coordinator" ]; then
        echo "No dmtcp_coordinator found. Check your DMTCP installation and PATH settings."
        exit 0
    fi

    dmtcp_coordinator --daemon --exit-on-last -p 0 --port-file $fname $@ 1>/dev/null 2>&1
    
    while true; do 
        if [ -f "$fname" ]; then
            p=`cat $fname`
            if [ -n "$p" ]; then
                # try to communicate ? dmtcp_command -p $p l
                break
            fi
        fi
    done
    
    # Create dmtcp_command wrapper for easy communication with coordinator
    p=`cat $fname`
    chmod +x $fname
    echo "#!/bin/bash" > $fname
    echo >> $fname
    echo "export PATH=$PATH" >> $fname
    echo "export DMTCP_COORD_HOST=$h" >> $fname
    echo "export DMTCP_COORD_PORT=$p" >> $fname
    echo "dmtcp_command \$@" >> $fname

    # Set up local environment for DMTCP
    export DMTCP_COORD_HOST=$h
    export DMTCP_COORD_PORT=$p

}

###################################################################################
# Print out the SLURM job information.  Remove this if you don't need it.
###################################################################################

# Print out the SLURM job information. Remove this if you don't need it.
echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR
echo "working directory = "$SLURM_SUBMIT_DIR

# changedir to workdir
cd $SLURM_SUBMIT_DIR


#----------------------------------- Set up job environment ------------------#

###############################################################################
# Load all nessesary modules or export PATH/LD_LIBRARY_PATH/etc here.
# Make sure that the prefix for the DMTCP install path is in PATH
# and LD_LIBRARY_PATH.
###############################################################################

#           **** IF USING Open MPI 1.8, SEE COMMENT BELOW ****
# module load openmpi
###############################################################################
# For Open MPI 1.8, if using InfiniBand, uncomment the following statement
# export OMPI_MCA_mpi_leave_pinned=0
# This could prevent a bug due to interaction with memalign() and ptmalloc2()
# on restart.
###############################################################################

# export PATH=<dmtcp-install-path>/bin:$PATH
# export LD_LIBRARY_PATH=<dmtcp-install-path>/lib:$LD_LIBRARY_PATH

#------------------------------------- Launch application ---------------------#

################################################################################
# 1. Start DMTCP coordinator
################################################################################

start_coordinator -i 10 #... <put dmtcp coordinator options here>


################################################################################
# 2. Launch application
# 2.1. If you use mpiexec/mpirun to launch an application, use the following
#      command line:
#        $ dmtcp_launch --rm mpiexec <mpi-options> ./<app-binary> <app-options>
# 2.2. If you use PMI1 to launch an application, use the following command line:
#        $ srun dmtcp_launch --rm ./<app-binary> <app-options>
# Note: PMI2 is not supported yet.
# 2.3. If you use the Stampede supercomputer at Texas Advanced Computing Center
#      (TACC), use ibrun command to launch the application (--rm is not required):
#        $ ibrun dmtcp_launch ./<app-binary> <app-options>
################################################################################

dmtcp_launch blastn -db genome.fa -query Homo.fa -num_threads 1

