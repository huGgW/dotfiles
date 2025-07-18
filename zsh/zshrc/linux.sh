# >>> Linux Specific >>>

# >>> Initialize zplug >>>
if [ -d /usr/share/zsh/scripts/zplug ]; then
	source /usr/share/zsh/scripts/zplug/init.zsh
	export ZPLUG_HOME=~/.zplug
elif [ -d ~/.zplug ]; then
	export ZPLUG_HOME=~/.zplug
	source $ZPLUG_HOME/init.zsh
fi
# <<< Initialize zplug <<<

# for amd MKL performance hack
export MKL_DEBUG_CPU_TYPE=5

# >>> ROCM >>>
export HSA_OVERRIDE_GFX_VERSION=10.3.0
export AMDGPU_TARGETS="gfx1030"
# <<< ROCM <<<

# alias for enable & disable sleep in systemctl linux
alias sleep_status="systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias sleep_disable="systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias sleep_enable="systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"

# >>> rofi path >>>
export PATH="$HOME/.config/rofi/scripts:$PATH"
# <<< rofi path <<<

# <<< Linux Specific <<<
