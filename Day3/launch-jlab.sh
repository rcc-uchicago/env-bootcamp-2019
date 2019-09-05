#!/bin/bash
#
########################################
# USER MODIFIABLE PARAMETERS:
 PART=edu              # partition name
 ACCOUNT=env_bootcamp  # account name
 TASKS=2               # 2 cores
 TIME="4:00:00"        # 4 hours
# PYTHON_MODULE="python/3.6.1+intel-16.0" # PyPi python module
 PYTHON_MODULE="Anaconda3/2018.12"          # Anaconda3 dist of python
########################################
#
#SET THE PORT NUMBER
PORT_NUM=$(shuf -i8000-9000 -n1)
#
# TRAP SIGINT AND SIGTERM OF THIS SCRIPT
function control_c {
    echo -en "\n SIGINT: TERMINATING SLURM JOBID $JOBID AND EXITING \n"
    scancel $JOBID
    rm jupyter-server.sbatch
    exit $?
}
trap control_c SIGINT
trap control_c SIGTERM
#
# SBATCH FILE FOR ALLOCATING COMPUTE RESOURCES TO RUN NOTEBOOK SERVER
create_sbatch() {
cat << EOF
#!/bin/bash
#
#SBATCH --partition=$PART
#SBATCH --account=$ACCOUNT
#SBATCH --ntasks=$TASKS
#SBATCH --cpus-per-task=1
#SBATCH --time=$TIME
#SBATCH -J nb_server
#SBATCH -o $CWD/session_logs/nb_session_%J.log

# LOAD A PYTHON MOUDLE WITH JUPYTER
module load $PYTHON_MODULE
#
# TO EXECUTE A NOTEBOOK TO CONNECT TO FROM YOUR LOCAL MACHINE YOU  NEED TO
# GET THE IP ADDRESS OF THE REMOTE MACHINE
export HOST_IP=\`hostname -i\`
launch='jupyter lab --no-browser --ContentsManager.allow_hidden=True --ip=\${HOST_IP} --port $PORT_NUM'
echo "  \$launch "
eval \$launch
EOF
}
#
# CREATE SESSION LOG FOLDER 
if [ ! -d session_logs ] ; then
   mkdir session_logs
fi
#
# CREATE JUPYTER NOTEBOOK SERVER SBATCH FILE
export CWD=`pwd`
create_sbatch > jupyter-server.sbatch
#
# START NOTEBOOK SERVER
#
export JOBID=$(sbatch jupyter-server.sbatch  | awk '{print $4}')
NODE=$(squeue -hj $JOBID -O nodelist )
if [[ -z "${NODE// }" ]]; then
   echo  " "
   echo -n "    WAITING FOR RESOURCES TO BECOME AVAILABLE (CTRL-C TO EXIT) ..."
fi
while [[ -z "${NODE// }" ]]; do
   echo -n "."
   sleep 2
   NODE=$(squeue -hj $JOBID -O nodelist )
done
#
# SLEEP A FEW SECONDS TO ENSURE SLURM JOB HAS SUBMITTED BEFORE WE USE SLURM ENV VARS
  echo -n "."
  sleep 2
NB_ADDRESS=$(grep "] http" session_logs/nb_session_${JOBID}.log | awk -F 'http' '{print $2}' )
  echo -n "."
while [ -z ${NB_ADDRESS} ] ; do 
  sleep 2
  echo -n "."
  NB_ADDRESS=$(grep "] http" session_logs/nb_session_${JOBID}.log | awk -F 'http' '{print $2}' )
done
NB_HOST_NAME=$(squeue -j $JOBID -h -o  %B)
HOST_IP=$(ssh -q $NB_HOST_NAME 'hostname -i')
NB_ADDRESS_IP=$( echo "$NB_ADDRESS"   | sed -e "s;\\?;lab/tree/master.ipynb\\?;g" )
NB_ADDRESS=$( echo "$NB_ADDRESS"   | sed -e "s/$HOST_IP/localhost/g" )
NB_ADDRESS=$( echo "$NB_ADDRESS"   | sed -e "s;\\?;lab/tree/master.ipynb\\?;g" )
  TIMELIM=$(squeue -hj $JOBID -O timeleft )
  if [[ $TIMELIM == *"-"* ]]; then
  DAYS=$(echo $TIMELIM | awk -F '-' '{print $1}')
  HOURS=$(echo $TIMELIM | awk -F '-' '{print $2}' | awk -F ':' '{print $1}')
  MINS=$(echo $TIMELIM | awk -F ':' '{print $2}')
  TIMELEFT="THIS SESSION WILL TIMEOUT IN $DAYS DAY $HOURS HOUR(S) AND $MINS MINS "
  else
  HOURS=$(echo $TIMELIM | awk -F ':' '{print $1}' )
  MINS=$(echo $TIMELIM | awk -F ':' '{print $2}')
  TIMELEFT="THIS SESSION WILL TIMEOUT IN $HOURS HOUR(S) AND $MINS MINS "
  fi
  echo " "
  echo "  --------------------------------------------------------------------"
  echo "    STARTING JUPYTER NOTEBOOK SERVER ON NODE $NODE           "
  echo "    $TIMELEFT"
  echo "    SESSION LOG WILL BE STORED IN nb_session_${JOBID}.log  "
  echo "  --------------------------------------------------------------------"
  echo "  "
  echo "    TO ACCESS THIS NOTEBOOK SERVER THERE ARE TWO OPTIONS THAT DEPEND  "
  echo "    ON WHETHER YOU ARE CONNECTED TO THE CAMPUS NETWORK OR NOT         "
  echo "  "
  echo "    IF CONNECTED TO THE CAMPUS NETWORK YOU SIMPLY NEED TO COPY AND    "
  echo "    AND PASTE THE FOLLOWING URL INTO YOUR LOCAL WEB BRWOSER: "
  echo "  "
  echo "    http${NB_ADDRESS_IP}  "
  echo "  "
  echo "    IF NOT ON THE CAMPUS NETWORK, DO THE FOLLOWING TWO STEPS "
  echo "  "
  echo "    1.) REVERSE TUNNEL FROM YOUR LOCAL MACHINE TO MIDWAY BY COPYING" 
  echo "        AND PASTING THE FOLLOWING SSH COMMAND TO YOUR LOCAL TERMINL"
  echo "        AND EXECUITING IT"
  echo "  "
  echo "     ssh -N -f -L $PORT_NUM:${HOST_IP}:${PORT_NUM} ${USER}@midway2.rcc.uchicago.edu "
  echo "  "
  echo "    2.) THEN LAUNCH THE JUPYTER LAB FROM YOUR LOCAL WEB BROWSER BY "
  echo "        COPYING AND PASTING THE FOLLOWING FULL URL WITH TOKEN INTO"
  echo "        YOUR LOCAL WEB BROWSER: " 
  echo "  "
  echo "    http${NB_ADDRESS}  "
  echo "  "
  echo "  --------------------------------------------------------------------"
  echo "    TO KILL THIS NOTEBOOK SERVER ISSUE THE FOLLOWING COMMAND: "
  echo "  "
  echo "       scancel $JOBID "
  echo "  "
  echo "  --------------------------------------------------------------------"
  echo "  "
#
# CLEANUP
  rm jupyter-server.sbatch
#
# EOF
