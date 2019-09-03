if [ $TERM == "xterm-256color" ] || [ $TERM == "screen" ]; then
  export PS1="\[\033[38;1;34m\]\u\[$(tput sgr0)\]\[\033[38;1;34m\]@\h:\[$(tput sgr0)\]\[\033[38;1;36m\][\w]:\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
fi

# Source global definitions.
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# SLURM.
export SACCT_FORMAT="jobid,partition,user,account%12,alloccpus,node%12,start,elapsed,totalcpu,maxRSS,ReqM"
export SQUEUE_FORMAT="%13i %12j %10P %10u %12a %8T %9r %10l %.11L %5D %4C %8m %N"

# User specific aliases and functions
alias mv='mv -iv'
alias rm='rm -iv'
alias cp='cp -iv'

