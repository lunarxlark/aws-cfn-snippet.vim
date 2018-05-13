# aws-cfn-snippet.vim

need [Shougo/neosnippet](https://github.com/Shougo/neosnippet.vim) Plugin.
check your snippet directory in vimrc.
```bash:vimrc
let g:neosnippet#snippets_directory='~/.vim/snippets/'
```

```bash
$ ./make-cfn-snippet.sh
$ cat yaml.snip >> $HOME/.vim/snippet/yaml.snip
```
