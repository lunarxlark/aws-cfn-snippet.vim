# aws-cfn-snippet.vim

## Make yaml and json snippet file for AWS CloudFormation.

you need [Shougo/neosnippet](https://github.com/Shougo/neosnippet.vim) Plugin.
check your snippet directory in vimrc.
```bash:vimrc
let g:neosnippet#snippets_directory='~/.vim/snippets/'
```

```bash
$ ./make-cfn-snippet.sh
$ cat yaml.snip >> ~/.vim/snippet/yaml.snip
$ cat json.snip >> ~/.vim/snippet/json.snip
```

## Sample
![Sample1](./sample1.png)
![Sample2](./sample2.png)
