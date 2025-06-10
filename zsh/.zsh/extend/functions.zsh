gfind() {
	rg --json -C 2 "$@" | delta
}
