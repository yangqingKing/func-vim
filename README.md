# vim-func

基于vim的函数列表插件
可以显示当前文件的函数列表，并支持跳转到指定函数的位置

## 安装方式
将func.vim复制到vim的plugin目录下
在vimrc中配置快捷键
```shell
nnoremap <C-t> :QShowFun<CR>
```

## 使用方式
1. 在vim普通模式下，按 `ctrl+t` 键打开函数列表窗口，再次按 `ctrl+t` 关闭窗口
2. 在函数列表窗口中，按 `o` 或者 `回车` 键，将跳转到指定函数的位置

