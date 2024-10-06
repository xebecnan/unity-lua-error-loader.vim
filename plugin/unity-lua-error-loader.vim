" Author: xebecnan https://github.com/xebecnan
" Description: utility functions for loading error messages from Unity

function! s:ListFiles(directory)
    " Get the list of files in the specified directory
    let files = split(glob(a:directory . '/*'), '\n')
    return files
endfunction

function! s:ChooseFile(files)
    " Create a temporary buffer to display the list of files
    new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    setlocal nomodifiable

    " Populate the buffer with the list of files
    call append(0, a:files)

    " Set up key mappings for choosing a file
    nnoremap <buffer> <CR> :call <SID>SelectFile(line('.'))<CR>
    nnoremap <buffer> q :q<CR>

    " Start in normal mode
    startinsert
endfunction

function! s:SelectFile(line)
    " Close the temporary buffer
    q

    " Open the selected file
    execute 'edit' a:line
endfunction

command! -nargs=1 ChooseFile call s:ChooseFile(s:ListFiles(<q-args>))
