if test -e "$HOME/.indeed-kube-profile"
    bass source "$HOME/.indeed-kube-profile"
end

function gcbj -d "Create a new branch with jira/ prefix"
    git checkout -b jira/$argv[1]
end

function gcj -d "Checkout jira/<name> if exists, otherwise checkout <name>"
    if git show-ref --verify --quiet refs/heads/jira/$argv[1]
        git checkout jira/$argv[1]
    else
        git checkout $argv[1]
    end
end
