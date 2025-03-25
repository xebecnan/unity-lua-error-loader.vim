" Author: xebecnan https://github.com/xebecnan
" Description: utility functions for loading error messages from Unity

fun! s:GetErrorDir()
    if !exists('g:unity_lua_error_dir')
        return ''
    else
        return g:unity_lua_error_dir
    endif
endfun

function! s:ListFiles(directory)
    " Get the list of files in the specified directory
    let files = split(glob(a:directory . '/*'), '\n')
    return files
endfunction

function! s:UnityLuaErrors()
    let dir = s:GetErrorDir()
    if dir == ''
        echoerr 'Error directory not set'
        return
    endif

    " check g:unity_lua_error_formatter
    if !exists('g:unity_lua_error_formatter')
        echoerr 'Error formatter not set'
        return
    endif

    let files = s:ListFiles(dir)
    if empty(files)
        echoerr 'No error files found in directory'
        return
    endif

    " Create menu items with indexes
    let menu = ['Choose an error file:']
    let idx = 1
    for file in files
        call add(menu, idx . '. ' . fnamemodify(file, ':t'))
        let idx += 1
    endfor

    let choice = inputlist(menu)
    if choice < 1 || choice > len(files)
        echo 'Selection cancelled'
        return
    endif

    call s:SelectFile(files[choice - 1])
endfunction

function! s:SelectFile(filename)
    " Create a new temporary buffer
    new

    " Make the buffer unlisted
    setlocal nobuflisted

    " Set the buffer type to 'nofile' to indicate it's not associated with a file
    setlocal buftype=nofile

    " Hide the buffer when switching away from it
    setlocal bufhidden=hide

    " Don't create a swap file for this buffer
    setlocal noswapfile

    " Make the buffer modifiable so we can edit it
    setlocal modifiable

    " Read the contents of the specified file into the buffer
    " execute '0read' a:filename

    " Optionally, move the cursor to the top of the buffer
    " normal! gg

    exec '%!' . g:unity_lua_error_formatter . ' ' . a:filename

    cgetexpr getline(1, '$')

    " Close the temporary buffer
    quit

    " Open the quickfix window
    copen
endfunction

command! -nargs=0 UnityLuaErrors call s:UnityLuaErrors()
