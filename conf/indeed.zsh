if [ -e "${HOME}/.indeed-kube-profile" ]; then
    . "${HOME}/.indeed-kube-profile"
fi
#eval "$(starship init zsh)"

# Create a new branch with jira/ prefix
gcbj() {
    git checkout -b jira/$1
}

# Checkout jira/<name> if exists, otherwise checkout <name>
gcj() {
    if git show-ref --verify --quiet refs/heads/jira/$1; then
        git checkout jira/$1
    else
        git checkout $1
    fi
}
