export PATH=$HOME/.custom/bin:$PATH
export PATH=$PATH:$HOME/.local/share/cargo/bin
export PATH=$PATH:$HOME/.local/bin

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

####  snapper配置(一键双子卷备份 + 更新 grub 菜单)  ####
alias snap-all='sudo snapper -c root create --description "Manual_ALL_$(date +%R)" && sudo snapper -c home create --description "Manual_ALL_$(date +%R)" && sudo grub-mkconfig -o /boot/grub/grub.cfg'

####  claude-code-router 配置  ####
alias ccr='~/Code/NodeJs/node_modules/.bin/ccr'

####  Maven  ####
export MAVEN_HOME="/opt/JetBrains/idea/plugins/maven/lib/maven3/"
export PATH=$MAVEN_HOME/bin:$PATH

####  Maven Daemon  ####
export MVND_HOME="/opt/maven-mvnd"
export MAVEN_HOME=$MVND_HOME/mvn
export PATH=$MVND_HOME/bin:$MAVEN_HOME/bin:$PATH

#### JDK  ####
export JAVA_HOME="/opt/java/zulu8.92.0.19-ca-jdk8.0.482"
# export JAVA_HOME="/opt/java/zulu21.48.15-ca-jdk21.0.10"
export PATH=$JAVA_HOME/bin:$PATH


[[ -f $HOME/.ssh/keys/keys.env ]] && source $HOME/.ssh/keys/keys.env
