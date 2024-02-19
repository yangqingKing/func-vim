" File: show_fun.vim
" 用于显示当前打开文件的函数列表
" Created by VIM.
" Author:YQ
" Date:2023/12/20 16:17:05

function! QShowFun()
    " 获取当前打开文件的函数列表
    let funId = getwinvar(win_getid(), 'show_funs')
    if empty(funId)
        let pathFileName = expand('%')
        let tagsCmd = 'ctags -x --php-kinds=f --format=1 '.pathFileName
        let funList = systemlist(tagsCmd)
        " 在新建窗口中显示函数列表
        if empty(funList)
            echo "No functions found."
        else
            "let yqFunOldWin = winnr()
            let yqFunOldWin = buffer_number()
            let bufFile = expand('%:p')
            let bufName = expand('%:t')
            " 创建右侧新建窗口
            vertical botright 30new

            set winfixwidth " 锁定窗口宽度
            setlocal buftype=nofile bufhidden=delete noswapfile nowrap winfixheight nonumber
            setlocal statusline=Functions
            let funWin = buffer_number()
            let w:yqFunLineCmd = []
            let w:yqFunOldWin = yqFunOldWin

            " 添加函数列表内容
            call append(0, " ** 函数列表 **")
            call append(1, "")
            call append(2, " 📖".bufName)
            call append(3, "")
            let row = 4
            for func in funList
                let funName = strpart(func, 0, stridx(func, " "))
                let funCmd = strpart(func, stridx(func, pathFileName) + strlen(pathFileName) + 1)

                call add(w:yqFunLineCmd, funCmd)
                " 在新建窗口中添加函数列表项
                call append(row, " 📜 " . funName . "()")
                let row = row + 1
            endfor
            call append(row+1, " ⚙️共[" . len(funList) . "]个函数⚙️")
            setlocal nomodifiable
            nnoremap <buffer> <CR> :call QExecFun(line('.'))<CR>
            nnoremap <buffer> o :call QExecFun(line('.'))<CR>

            let win = win_findbuf(yqFunOldWin)[0]
            echo win
            call setwinvar(getwininfo(win)[0].winnr, 'show_funs', funWin)
        endif
    else
        let w:show_funs = 0
        let win = win_findbuf(funId)
        if !empty(win)
            exe getwininfo(win[0])[0].winnr.'wincmd c'
        endif
    endif

endfunction

" 跳转到函数
function! QExecFun(lineno)
    if(a:lineno > 4)
        let idx = a:lineno - 5
        let winInfo = getwininfo(win_getid())[0]
        let winVar = winInfo['variables']
        if(idx < len(winVar.yqFunLineCmd))
            let text = trim(winVar.yqFunLineCmd[idx], "/^$'/")
            let bufferId = winnr()
            let winIdList =  win_findbuf(winVar.yqFunOldWin)
            for id in winIdList
                exe getwininfo(id)[0].winnr.'wincmd w'
                exe 'silent! /'. escape(trim(text), "[]")
            endfor
            exe bufferId.'wincmd w'
        endif
    endif
endfunction

command! QShowFun :call QShowFun()

