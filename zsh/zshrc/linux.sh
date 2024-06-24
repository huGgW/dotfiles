# >>> Linux Specific >>>

# for amd MKL performance hack
export MKL_DEBUG_CPU_TYPE=5

# >>> ROCM docker >>>
# alias for docker rocm
alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -e HSA_OVERRIDE_GFX_VERSION=10.3.0'
export HSA_OVERRIDE_GFX_VERSION=10.3.0
export AMDGPU_TARGETS="gfx1030"
# <<< ROCM docker <<<

# alias for enable & disable sleep in systemctl linux
if [[ `uname` != "Darwin" ]]; then
	alias sleep_status="systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target"
	alias sleep_disable="systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
	alias sleep_enable="systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"
fi

# <<< Linux Specific <<<
