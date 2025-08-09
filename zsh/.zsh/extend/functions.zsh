gfind() {
	rg --json -C 2 "$@" | delta
}

weather() {
	curl "https://wttr.in/?format=v2" 2>/dev/null | less --raw-control-chars
}
