# Prompt user@host:full path working directory
export PS1="\u@\h:\w$ "

# Git
alias gs="git status"
alias ga="git add ."
alias gm="git commit -m"
alias gb="git branch"
alias push="git push origin"
alias pull="git pull origin"

# Utility
alias mv="mv -iv"
alias cp="cp -iv"
alias ..="cd .."
alias l="ls -aF"
alias ll="ls -laF"
alias reload="source ~/.bashrc"
alias fap="fab"
alias ds="sudo find / -name ".DS_Store" -depth -exec rm {} \;"

# Compass
alias watch="compass watch"
alias min="compass compile --output-style compressed --force"
alias compass_new='compass create --bare --syntax sass --sass-dir "src/sass" --css-dir "static/css" --javascripts-dir "static/js" --images-dir "static/img"'

# User specific aliases and functions
# virtualenv
source /usr/local/bin/virtualenvwrapper.sh
export WORKON_HOME=~/Sites/.virtualenvs
export PROJECT_HOME=~/Sites/work/
#virtualenvwrapper
#passes arg to virtual env commands so it doesn't inherit any packages
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

#pip
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

#fab
alias fab="fab -f conf/fabfile.py"

export EDITOR="/usr/local/bin/mate -w"


        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

function parse_git_branch {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  detached_branch_pattern="# Not currently on any branch"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status}} =~ "Changed but not updated" ]]; then
    state="${RED}⚡"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
    else
      remote="${YELLOW}↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
    branch="${YELLOW}NO BRANCH"
  fi

  if [[ ${#state} -gt "0" || ${#remote} -gt "0" ]]; then
    s=" "
  fi

  echo " ${branch}${s}${remote}${state}"
}

function prompt_func() {
  git rev-parse --git-dir > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    prompt="${TITLEBAR}${BLUE}[${LIGHT_GRAY}\w${GREEN}$(parse_git_branch)${BLUE}]${COLOR_NONE} "
    PS1="${prompt}$ "
  else
    PS1=$PSAVE
  fi
}

export PSAVE=$PS1

PROMPT_COMMAND=prompt_func