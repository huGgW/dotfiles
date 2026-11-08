# >>> Linux Specific >>>

# for amd MKL performance hack
export MKL_DEBUG_CPU_TYPE=5

# alias for enable & disable sleep in systemctl linux
alias sleep_status="systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias sleep_disable="systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias sleep_enable="systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"

# <<< Linux Specific <<<
