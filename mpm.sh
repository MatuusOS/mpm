addrepo() {
    sleep 5
    echo "Please specify a site with required metadata"
    cd /usr/share/mpm/repolists/
    mkdir -p /usr/share/mpm/repolists/
    touch /usr/share/mpm/repolists/repos.txt
    read varname >> repos.txt
}	

install() {
	export REPO_LIST=/usr/share/mpm/repolists/repos.txt
    cd /usr/share/mpm/repolists/
    cat repos.txt | grep REPO
}