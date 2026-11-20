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

function dec -d "Enter sandbox"
    set -l container turbo-umbrella-studio-1
    set -l dir (string replace -r '^/Users/bedwards/claude-workspace(?=/|$)' '/home/dev/workspace' -- $PWD \
      | string replace -r '^/Users/bedwards(?=/|$)' '/home/dev')
    set -l workdir
    if /usr/local/bin/docker exec $container test -d $dir
        set workdir -w $dir
    end
    /usr/local/bin/docker exec -it $workdir $container /home/dev/.nix-profile/bin/fish
end